using System;
using System.Diagnostics;
using System.IO;
using System.IO.Compression;
using System.Runtime.InteropServices;
using System.Windows.Forms;
using Microsoft.Win32;
using AppGo.Controller;
using AppGo.Model;
using AppGo.View;
using AppGo.View.CustomControls;
using System.Text;
using System.Security.Cryptography;
using System.Linq;
using System.Net;
using System.ServiceProcess;
using System.Threading;

namespace AppGo.Util
{
    public struct BandwidthScaleInfo
    {
        public float value;
        public string unitName;
        public long unit;

        public BandwidthScaleInfo(float value, string unitName, long unit)
        {
            this.value = value;
            this.unitName = unitName;
            this.unit = unit;
        }
    }

    public static class Utils
    {
        private static string PROXY_PATH = "appgo";

        private static AGMessageBoxForm _messageBox;
        private static string _tempPath = null;

        // return path to store temporary files
        public static string GetTempPath()
        {
            if (_tempPath == null)
            {
                bool isPortableMode = AppPref.Load().portableMode;
                try
                {
                    if (isPortableMode)
                    {
                        _tempPath = Directory.CreateDirectory(Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), PROXY_PATH)).FullName;
                        // don't use "/", it will fail when we call explorer /select xxx/appgo_temp\xxx.log
                    }
                    else
                    {
                        _tempPath = Directory.CreateDirectory(Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), PROXY_PATH)).FullName;
                        //_tempPath = Directory.CreateDirectory(Path.Combine(Path.GetTempPath(), @"AppGo\appgo_temp_" + Application.ExecutablePath.GetHashCode())).FullName;
                    }
                }
                catch (Exception e)
                {
                    Logging.Error(e);
                    throw;
                }
            }
            return _tempPath;
        }

        // return a full path with filename combined which pointed to the temporary directory
        public static string GetTempPath(string filename)
        {
            return Path.Combine(GetTempPath(), filename);
        }

        public static void ReleaseMemory(bool removePages)
        {
            // release any unused pages
            // making the numbers look good in task manager
            // this is totally nonsense in programming
            // but good for those users who care
            // making them happier with their everyday life
            // which is part of user experience
            GC.Collect(GC.MaxGeneration);
            GC.WaitForPendingFinalizers();
            if (removePages)
            {
                // as some users have pointed out
                // removing pages from working set will cause some IO
                // which lowered user experience for another group of users
                //
                // so we do 2 more things here to satisfy them:
                // 1. only remove pages once when configuration is changed
                // 2. add more comments here to tell users that calling
                //    this function will not be more frequent than
                //    IM apps writing chat logs, or web browsers writing cache files
                //    if they're so concerned about their disk, they should
                //    uninstall all IM apps and web browsers
                //
                // please open an issue if you're worried about anything else in your computer
                // no matter it's GPU performance, monitor contrast, audio fidelity
                // or anything else in the task manager
                // we'll do as much as we can to help you
                //
                // just kidding
                SetProcessWorkingSetSize(Process.GetCurrentProcess().Handle,
                                         (UIntPtr)0xFFFFFFFF,
                                         (UIntPtr)0xFFFFFFFF);
            }
        }

        public static string UnGzip(byte[] buf)
        {
            byte[] buffer = new byte[1024];
            int n;
            using (MemoryStream sb = new MemoryStream())
            {
                using (GZipStream input = new GZipStream(new MemoryStream(buf),
                                                         CompressionMode.Decompress,
                                                         false))
                {
                    while ((n = input.Read(buffer, 0, buffer.Length)) > 0)
                    {
                        sb.Write(buffer, 0, n);
                    }
                }
                return System.Text.Encoding.UTF8.GetString(sb.ToArray());
            }
        }

        public static string FormatBandwidth(long n)
        {
            var result = GetBandwidthScale(n);
            return $"{result.value:0.##}{result.unitName}";
        }

        public static string FormatBytes(long bytes)
        {
            const long K = 1024L;
            const long M = K * 1024L;
            const long G = M * 1024L;
            const long T = G * 1024L;
            const long P = T * 1024L;
            const long E = P * 1024L;

            if (bytes >= P * 990)
                return (bytes / (double)E).ToString("F5") + "EiB";
            if (bytes >= T * 990)
                return (bytes / (double)P).ToString("F5") + "PiB";
            if (bytes >= G * 990)
                return (bytes / (double)T).ToString("F5") + "TiB";
            if (bytes >= M * 990)
            {
                return (bytes / (double)G).ToString("F4") + "GiB";
            }
            if (bytes >= M * 100)
            {
                return (bytes / (double)M).ToString("F1") + "MiB";
            }
            if (bytes >= M * 10)
            {
                return (bytes / (double)M).ToString("F2") + "MiB";
            }
            if (bytes >= K * 990)
            {
                return (bytes / (double)M).ToString("F3") + "MiB";
            }
            if (bytes > K * 2)
            {
                return (bytes / (double)K).ToString("F1") + "KiB";
            }
            return bytes.ToString() + "B";
        }

        /// <summary>
        /// Return scaled bandwidth
        /// </summary>
        /// <param name="n">Raw bandwidth</param>
        /// <returns>
        /// The BandwidthScaleInfo struct
        /// </returns>
        public static BandwidthScaleInfo GetBandwidthScale(long n)
        {
            long scale = 1;
            float f = n;
            string unit = "B";
            if (f > 1024)
            {
                f = f / 1024;
                scale <<= 10;
                unit = "KiB";
            }
            if (f > 1024)
            {
                f = f / 1024;
                scale <<= 10;
                unit = "MiB";
            }
            if (f > 1024)
            {
                f = f / 1024;
                scale <<= 10;
                unit = "GiB";
            }
            if (f > 1024)
            {
                f = f / 1024;
                scale <<= 10;
                unit = "TiB";
            }
            return new BandwidthScaleInfo(f, unit, scale);
        }

        public static RegistryKey OpenRegKey(string name, bool writable, RegistryHive hive = RegistryHive.CurrentUser)
        {
            // we are building x86 binary for both x86 and x64, which will
            // cause problem when opening registry key
            // detect operating system instead of CPU
            if (name.IsNullOrEmpty()) throw new ArgumentException(nameof(name));
            try
            {
                RegistryKey userKey = RegistryKey.OpenBaseKey(hive,
                        Environment.Is64BitOperatingSystem ? RegistryView.Registry64 : RegistryView.Registry32)
                    .OpenSubKey(name, writable);
                return userKey;
            }
            catch (ArgumentException ae)
            {
                Utils.ShowMessageBox("OpenRegKey: " + ae.ToString());
                return null;
            }
            catch (Exception e)
            {
                Logging.Error(e);
                return null;
            }
        }

        public static bool IsWinVistaOrHigher()
        {
            return Environment.OSVersion.Version.Major > 5;
        }

        [DllImport("kernel32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        private static extern bool SetProcessWorkingSetSize(IntPtr process,
            UIntPtr minimumWorkingSetSize, UIntPtr maximumWorkingSetSize);


        // See: https://msdn.microsoft.com/en-us/library/hh925568(v=vs.110).aspx
        public static bool IsSupportedRuntimeVersion()
        {
            /*
             * +-----------------------------------------------------------------+----------------------------+
             * | Version                                                         | Value of the Release DWORD |
             * +-----------------------------------------------------------------+----------------------------+
             * | .NET Framework 4.5.1 installed on Windows 10 Anniversary Update | 394802                     |
             * | .NET Framework 4.5.1 installed on all other Windows OS versions | 394806                     |
             * +-----------------------------------------------------------------+----------------------------+
             */
            const int minSupportedRelease = 378675;
            //const int minSupportedRelease = 393297;

            const string subkey = @"SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full\";
            using (var ndpKey = OpenRegKey(subkey, false, RegistryHive.LocalMachine))
            {
                if (ndpKey?.GetValue("Release") != null)
                {
                    var releaseKey = (int)ndpKey.GetValue("Release");

                    if (releaseKey >= minSupportedRelease)
                    {
                        return true;
                    }
                }
            }
            return false;
        }

        public static bool IsValidEmailAddress(string email)
        {
            try
            {
                var mailAddress = new System.Net.Mail.MailAddress(email);
                return true;
            }
            catch
            {
                return false;
            }
        }

        public static DialogResult ShowMessageBox(string message)
        {
            return ShowMessageBox(null, message);
        }

        public static DialogResult ShowYesNoMessageBox(Form parent, string message)
        {
            return ShowMessageBox(parent, message, true);
        }

        public static DialogResult ShowMessageBox(Form parent, string message, bool showCancel = false)
        {
            if (_messageBox != null)
                _messageBox.Close();

            _messageBox = new AGMessageBoxForm(showCancel);
            _messageBox.FormClosed += new FormClosedEventHandler(MessageBox_FormClosed);
            _messageBox.Message = message;
            _messageBox.StartPosition = (parent != null ? FormStartPosition.CenterParent : FormStartPosition.CenterScreen);

            if (parent == null && Program.ViewController != null && Program.ViewController.MainForm != null)
                parent = Program.ViewController.MainForm;

            if (parent != null)
            {
                parent.AddOwnedForm(_messageBox);
                return _messageBox.ShowDialog();
            }
            else
            {
                _messageBox.Show();
                _messageBox.Activate();
                return DialogResult.OK;
            }            
        }

        private static void MessageBox_FormClosed(object sender, FormClosedEventArgs e)
        {
            if (_messageBox != null)
            {
                _messageBox.Dispose();
                _messageBox = null;
            }
            
            ReleaseMemory(true);
        }

        public static bool ValidateCountryAndRule(AGService server, string rule)
        {
            if (server.country.name == "CN" && rule == VPNRule.INTERNATIONAL)
            {
                return false;
            }
            else if (server.country.name != "CN" && rule == VPNRule.NATIONAL)
            {
                return false;
            }

            return true;
        }

        public static string GetMaskedPhoneNumber(string mobile)
        {
            if (!mobile.Contains("+"))
                return "";
            string maskedNum = "";
            for (int i = 0; i < CountryTemplate.CountryInfos.Length; i++)
            {
                string countryCode = mobile.Substring(0, 4);
                if (countryCode == CountryTemplate.CountryInfos[i].PhoneCode)
                {
                    maskedNum = mobile.Substring(4, mobile.Length - 11) + FillMaskCode(4) + mobile.Substring(mobile.Length-3);
                    break;
                }
                countryCode = mobile.Substring(0, 3);
                if (countryCode == CountryTemplate.CountryInfos[i].PhoneCode)
                {
                    maskedNum = mobile.Substring(3, mobile.Length-10) + FillMaskCode(4) + mobile.Substring(mobile.Length - 3);
                    break;
                }
                countryCode = mobile.Substring(0, 2);
                if (countryCode == CountryTemplate.CountryInfos[i].PhoneCode)
                {
                    maskedNum = mobile.Substring(2, mobile.Length - 9) + FillMaskCode(4) + mobile.Substring(mobile.Length - 3);
                    break;
                }
            }
            return maskedNum;
        }

        public static string GetPhoneCountryCode(string mobile)
        {
            if (!mobile.Contains("+"))
                return "";
            string CodeNum = "";
            for (int i = 0; i < CountryTemplate.CountryInfos.Length; i++)
            {
                string CountryCode = mobile.Substring(0, 4);
                if (CountryCode == CountryTemplate.CountryInfos[i].PhoneCode)
                {
                    CodeNum = CountryCode;
                    break;
                }
                CountryCode = mobile.Substring(0, 3);
                if (CountryCode == CountryTemplate.CountryInfos[i].PhoneCode)
                {
                    CodeNum = CountryCode;
                }
                CountryCode = mobile.Substring(0, 2);
                if (CountryCode == CountryTemplate.CountryInfos[i].PhoneCode)
                {
                    CodeNum = CountryCode;
                }
            }
            return CodeNum;
        }

        public static string GetNativePhoneNumber(string mobile)
        {
            if (!mobile.Contains("+"))
                return "";
            string NativeNum = "";
            for (int i = 0; i < CountryTemplate.CountryInfos.Length; i++)
            {
                String countryCode = mobile.Substring(0, 4);
                if (countryCode == CountryTemplate.CountryInfos[i].PhoneCode)
                {
                    NativeNum = mobile.Substring(4);
                    break;
                }
                countryCode = mobile.Substring(0, 3);
                if (countryCode == CountryTemplate.CountryInfos[i].PhoneCode)
                {
                    NativeNum = mobile.Substring(3);
                    break;
                }
                countryCode = mobile.Substring(0, 2);
                if (countryCode == CountryTemplate.CountryInfos[i].PhoneCode)
                {
                    NativeNum = mobile.Substring(2);
                    break;
                }
            }
            return NativeNum;
        }

        public static String FillMaskCode(int count)
        {
            String result = "";
            for (int i = 0; i < count; i++)
            {
                result += "*";
            }
            return result;
        }

        public static string GetLocalizedDescription(string Desc)
        {
            String[] LocalizedDescs = Desc.Split(new String[] { " | "}, StringSplitOptions.None);
            if (LocalizedDescs.Length > 1)
            {
                if (LocalizationManager.CurrentLanguage == LocalizationManager.Chinese)
                    return LocalizedDescs[0];
                else
                    return LocalizedDescs[1];
            }
            else
                return "";
        }

        public static String FormatToHumanReadableFileSize(object Value, bool NeedFloat = true)
        {
            try
            {
                string[] suffixNames = { "bytes", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB" };
                var counter = 0;
                decimal dValue = 0;
                Decimal.TryParse(Value.ToString(), out dValue);
                while (Math.Round(dValue / 1024) >= 1 && counter < 3)
                {
                    dValue /= 1024;
                    counter++;
                }

                if (NeedFloat)
                    return string.Format("{0:n2} {1}", dValue, suffixNames[counter]);
                else
                    return string.Format("{0:n0} {1}", dValue, suffixNames[counter]);
            }
            catch (Exception ex)
            {
                //catch and handle the exception
                return string.Empty;
            }
        }    
        
        public static bool StatusCode(HttpStatusCode code)
        {
            if (code >= HttpStatusCode.OK && code < HttpStatusCode.MultipleChoices)
                return true;
            else
                return false;
        }

        public static ServiceController GetService(string serviceName)
        {
            ServiceController[] services = ServiceController.GetServices();
            foreach (ServiceController service in services)
            {
                if (service.ServiceName == serviceName)
                    return service;
            }
            return null;            
        }

        public static bool IsServiceRunning(string serviceName)
        {
            ServiceControllerStatus status;
            uint counter = 0;
            do
            {
                ServiceController service = GetService(serviceName);
                if (service == null)
                {
                    return false;
                }

                Thread.Sleep(100);
                status = service.Status;
            } while (!(status == ServiceControllerStatus.Stopped ||
                       status == ServiceControllerStatus.Running) &&
                     (++counter < 30));
            return status == ServiceControllerStatus.Running;
        }

        public static bool IsServiceInstalled(string serviceName)
        {
            return GetService(serviceName) != null;
        }

        public static void StartService(string serviceName)
        {
            ServiceController controller = GetService(serviceName);
            if (controller == null)
            {
                return;
            }

            controller.Start();
            controller.WaitForStatus(ServiceControllerStatus.Running);
        }

        public static void StopService(string serviceName)
        {
            ServiceController controller = GetService(serviceName);
            if (controller == null)
            {
                return;
            }

            if (IsServiceRunning(serviceName))
            {
                controller.Stop();
                controller.WaitForStatus(ServiceControllerStatus.Stopped);
            }            
        }
    }
}
