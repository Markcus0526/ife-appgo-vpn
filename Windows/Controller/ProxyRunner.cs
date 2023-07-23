using AppGo.Model;
using AppGo.Properties;
using AppGo.Util;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.IO.Pipes;
using System.Linq;
using System.Net.Sockets;
using System.Runtime.Serialization;
using System.ServiceProcess;
using System.Threading;


namespace AppGo.Controller
{
    class ProxyRunner
    {   
        private static string PROXY_IP = "127.0.0.1";
        private static int SS_LOCAL_PORT = 1084;
        private static string TUN2SOCKS_TAP_DEVICE_NAME = "AppGo";
        // TODO: read these from the network device!
        private static string TUN2SOCKS_TAP_DEVICE_IP = "10.0.88.2";
        private static string TUN2SOCKS_VIRTUAL_ROUTER_IP = "10.0.88.1";
        private static string TUN2SOCKS_TAP_DEVICE_NETWORK = "10.0.88.0";
        private static string TUN2SOCKS_VIRTUAL_ROUTER_NETMASK = "255.255.255.0";

        private static uint SS_LOCAL_TIMEOUT_SECS = 2147483647;  // 32-bit INT_MAX; using Number.MAX_SAFE_VALUE may overflow
        private static int REACHABILITY_TEST_TIMEOUT_MS = 10000;
        private static int CONNECT_RETRY_COUNT = 2;
        //private static int DNS_LOOKUP_TIMEOUT_MS = 10000;
        //private static int UDP_FORWARDING_TEST_TIMEOUT_MS = 5000;
        //private static int UDP_FORWARDING_TEST_RETRY_INTERVAL_MS = 1000;

        private const string SERVICE_NAME = "AppGoService";
        private const string SERVICE_PIPE_PATH = "\\\\.\\pipe\\";
        private const string SERVICE_PIPE_NAME = "AppGoServicePipe"; // Must be kept in sync with electron.
        private const string ACTION_CONFIGURE_ROUTING = "configureRouting";
        private const string ACTION_RESET_ROUTING = "resetRouting";
        private const string PARAM_ROUTER_IP = "routerIp";
        private const string PARAM_PROXY_IP = "proxyIp";
        private const string PARAM_AUTO_CONNECT = "isAutoConnect";
        
        private bool needConnect = false;
        private Process tun2sockProcess = null, ssProcess = null;
        private int connectRetry = 0;
        private static Job processJob;


        public ProxyRunner()
        {
            processJob = new Job();
        }

        public void initRunner(bool init)
        {
            Process[] existingProxy = Process.GetProcessesByName("appgo-ss");
            foreach (Process p in existingProxy)
            {
                KillProcess(p);
            }

            existingProxy = Process.GetProcessesByName("appgo-tun2socks");
            foreach (Process p in existingProxy)
            {
                KillProcess(p);
            }
            

            FileManager.UncompressFile(Utils.GetTempPath("add_tap_device.bat"), Resources.add_tap_device_bat);            
            FileManager.UncompressFile(Utils.GetTempPath("appgo-tun2socks.exe"), Resources.appgo_tun2socks_exe);
            FileManager.UncompressFile(Utils.GetTempPath("appgo-ss.exe"), Resources.appgo_ss_exe);

            if (Environment.Is64BitOperatingSystem)
            {
                FileManager.UncompressFile(Utils.GetTempPath("OemVista.inf"), Resources.amd64_OemVista_inf);
                FileManager.UncompressFile(Utils.GetTempPath("tap0901.cat"), Resources.amd64_tap0901_cat);
                FileManager.UncompressFile(Utils.GetTempPath("tap0901.sys"), Resources.amd64_tap0901_sys);
                FileManager.UncompressFile(Utils.GetTempPath("tapinstall.exe"), Resources.amd64_tapinstall_exe);
            }
            else
            {
                FileManager.UncompressFile(Utils.GetTempPath("OemVista.inf"), Resources.i386_OemVista_inf);
                FileManager.UncompressFile(Utils.GetTempPath("tap0901.cat"), Resources.i386_tap0901_cat);
                FileManager.UncompressFile(Utils.GetTempPath("tap0901.sys"), Resources.i386_tap0901_sys);
                FileManager.UncompressFile(Utils.GetTempPath("tapinstall.exe"), Resources.i386_tapinstall_exe);
            }

            Process process = new Process
            {
                // Configure the process using the StartInfo properties.
                StartInfo =
                {
                    FileName = Utils.GetTempPath("add_tap_device.bat"),
                    Arguments = Environment.Is64BitOperatingSystem ? "amd64" : "i386",
                    WorkingDirectory = Utils.GetTempPath(),
                    WindowStyle = ProcessWindowStyle.Hidden,
                    UseShellExecute = false,
                    CreateNoWindow = true
                }
            };
            process.Start();
            process.WaitForExit();

            if (!init)
                return;

            Utils.StopService(SERVICE_NAME);

            FileManager.UncompressFile(Utils.GetTempPath("AppGoService.exe"), Resources.AppGoService_exe);
            FileManager.UncompressFile(Utils.GetTempPath("Newtonsoft.Json.dll"), Resources.Newtonsoft_Json_dll);
            FileManager.UncompressFile(Utils.GetTempPath("install_windows_service.bat"), Resources.install_windows_service_bat);

            process = new Process
            {
                // Configure the process using the StartInfo properties.
                StartInfo =
                {
                    FileName = Utils.GetTempPath("install_windows_service.bat"),
                    WorkingDirectory = Utils.GetTempPath(),
                    WindowStyle = ProcessWindowStyle.Hidden,
                    UseShellExecute = false,
                    CreateNoWindow = true
                }
            };
            process.Start();
            process.WaitForExit();            
        }

        public bool Start(AppPref config)
        {
            AGService service = config.GetCurrentService();
            if (service == null)
                return false;

            /*service.server_ip = "220.246.59.204";
            service.server_port = 5072;
            service.password = "vw94b3n3";*/

            needConnect = config.enabled;

            StartLocalShadowsocksProxy(service);

            if (!IsConnectServer(service.server_ip, service.server_port, REACHABILITY_TEST_TIMEOUT_MS))
                return false;

            connectRetry = 0;
            StartTun2socks();

            return RouteService(service);
        }

        public bool Stop(bool result)
        {
            needConnect = false;

            ResetService();

            if (ssProcess != null)
            {
                KillProcess(ssProcess);
                ssProcess.Dispose();
                ssProcess = null;
            }

            if (tun2sockProcess != null)
            {
                KillProcess(tun2sockProcess);
                tun2sockProcess.Dispose();
                tun2sockProcess = null;
            }

            return result;        
        }

        private static void KillProcess(Process p)
        {
            try
            {
                p.CloseMainWindow();
                p.WaitForExit(100);
                if (!p.HasExited)
                {
                    p.Kill();
                    p.WaitForExit();
                }
            }
            catch (Exception e)
            {
                Logging.Error(e);
            }
        }
                
        private bool StartLocalShadowsocksProxy(AGService service)
        {
            if (service == null)
                return false;
            
            string arguments = $"-l {SS_LOCAL_PORT} -s {service.server_ip} -p {service.server_port} -k {service.password} -m {service.method} -t {SS_LOCAL_TIMEOUT_SECS} -u";

            Process[] existingProxy = Process.GetProcessesByName("appgo-ss");
            foreach (Process p in existingProxy)
            {
                KillProcess(p);
            }

            // register service
            ssProcess = new Process
            {
                // Configure the process using the StartInfo properties.
                StartInfo =
                {
                    FileName = Utils.GetTempPath("appgo-ss.exe"),
                    Arguments = arguments,
                    WorkingDirectory = Utils.GetTempPath(),
                    WindowStyle = ProcessWindowStyle.Hidden,
                    UseShellExecute = false,
                    CreateNoWindow = true
                }
            };
            ssProcess.Start();
            ssProcess.EnableRaisingEvents = true;
            ssProcess.Exited += new EventHandler(SSProcessExited);

            //processJob.AddProcess(ssProcess.Handle);

            return true;
        }

        private void SSProcessExited(object sender, System.EventArgs e)
        {
            if (needConnect)
            {
                ssProcess = null;
                Stop(false);
            }
        }

        private bool StartTun2socks()
        {
            string arguments = $"--tundev tap0901:{TUN2SOCKS_TAP_DEVICE_NAME}:{TUN2SOCKS_TAP_DEVICE_IP}:{TUN2SOCKS_TAP_DEVICE_NETWORK}:{TUN2SOCKS_VIRTUAL_ROUTER_NETMASK}";
            arguments += $" --netif-ipaddr {TUN2SOCKS_VIRTUAL_ROUTER_IP} --netif-netmask {TUN2SOCKS_VIRTUAL_ROUTER_NETMASK} --socks-server-addr {PROXY_IP}:{SS_LOCAL_PORT}";
            arguments += $" --socks5-udp --udp-relay-addr {PROXY_IP}:{SS_LOCAL_PORT} --loglevel error";

            Process[] existingProxy = Process.GetProcessesByName("appgo-tun2socks");
            foreach (Process p in existingProxy)
            {
                KillProcess(p);
            }

            // register service
            tun2sockProcess = new Process
            {
                // Configure the process using the StartInfo properties.
                StartInfo =
                {
                    FileName = Utils.GetTempPath("appgo-tun2socks.exe"),
                    Arguments = arguments,
                    WorkingDirectory = Utils.GetTempPath(),
                    WindowStyle = ProcessWindowStyle.Hidden,
                    UseShellExecute = false,
                    CreateNoWindow = true
                }
            };
            tun2sockProcess.Start();
            tun2sockProcess.EnableRaisingEvents = true;
            tun2sockProcess.Exited += new EventHandler(SockProcessExited);

            //processJob.AddProcess(ssProcess.Handle);

            return true;   
        }

        private void SockProcessExited(object sender, System.EventArgs e)
        {
            if (needConnect)
            {
                if (connectRetry < CONNECT_RETRY_COUNT)
                {
                    Thread.Sleep(3000);
                    connectRetry += 1;
                    StartTun2socks();
                }
                else
                {
                    tun2sockProcess = null;
                    Stop(false);
                }
            }                        
        }

        private bool IsConnectServer(string host, int port, int timeout)
        {
            try
            {
                using (var client = new TcpClient())
                {
                    var result = client.BeginConnect(host, port, null, null);
                    var success = result.AsyncWaitHandle.WaitOne(timeout);
                    if (!success)
                    {
                        return false;
                    }

                    client.EndConnect(result);
                }
            }
            catch
            {
                return false;
            }
            return true;
        }

        private bool RouteService(AGService service)
        {
            //var pipeClient = new NamedPipeClientStream(SERVICE_PIPE_PATH, SERVICE_PIPE_NAME, PipeDirection.InOut, PipeOptions.Asynchronous);            
            var pipeClient = new NamedPipeClientStream(SERVICE_PIPE_NAME);
            if (pipeClient.IsConnected != true) { pipeClient.Connect(); }

            StreamReader sr = new StreamReader(pipeClient);
            StreamWriter sw = new StreamWriter(pipeClient);

            ServiceRequest request = new ServiceRequest();
            request.action = ACTION_CONFIGURE_ROUTING;
            request.parameters = new Dictionary<string, string>();
            request.parameters.Add(PARAM_ROUTER_IP, TUN2SOCKS_VIRTUAL_ROUTER_IP);
            request.parameters.Add(PARAM_PROXY_IP, service.server_ip);
            request.parameters.Add(PARAM_AUTO_CONNECT, "false");
            try
            {
                string JsonString = JsonConvert.SerializeObject(request, Formatting.Indented);
                sw.WriteLine(JsonString);
                sw.Flush();

                string temp;
                temp = sr.ReadLine();

                pipeClient.Close();                
            }
            catch (Exception ex)
            {
                Logging.Error(ex);
                return false;
            }
            return true;
        }

        private bool ResetService()
        {
            var pipeClient = new NamedPipeClientStream(SERVICE_PIPE_NAME);
            if (pipeClient.IsConnected != true) { pipeClient.Connect(); }

            StreamReader sr = new StreamReader(pipeClient);
            StreamWriter sw = new StreamWriter(pipeClient);

            ServiceRequest request = new ServiceRequest();
            request.action = ACTION_RESET_ROUTING;
            request.parameters = new Dictionary<string, string>();            
            try
            {
                string JsonString = JsonConvert.SerializeObject(request, Formatting.Indented);
                sw.WriteLine(JsonString);
                sw.Flush();

                string temp;
                temp = sr.ReadLine();

                pipeClient.Close();                
            }
            catch (Exception ex)
            {
                Logging.Error(ex);
                return false;
            }
            return true;
        }        
    }

    [DataContract]
    internal class ServiceRequest
    {
        [DataMember]
        internal string action;
        [DataMember]
        internal Dictionary<string, string> parameters;
    }

    [DataContract]
    internal class ServiceResponse
    {
        [DataMember]
        internal int statusCode;
        [DataMember]
        internal string errorMessage;
    }
}

