using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.NetworkInformation;
using System.Net.Sockets;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using AppGo.Model;

namespace AppGo.Controller
{
    public class AGPing
    {
        //arguments for ICMP tests
        public const int TimeoutMilliseconds = 500;

        public EventHandler<CompletedEventArgs> Completed;
        private AGService server;

        private int repeat;
        private IPAddress ip;
        private Ping ping;
        private List<int?> RoundtripTime;

        public AGPing(AGService server, int repeat)
        {
            this.server = server;
            this.repeat = repeat;
            RoundtripTime = new List<int?>(repeat);
            ping = new Ping();
            ping.PingCompleted += Ping_PingCompleted;
        }

        public void Start(object userState)
        {
            if (server.server_ip == "")
            {
                FireCompleted(new Exception("Invalid Server"), userState);
                return;
            }
            new Task(() => ICMPTest(0, userState)).Start();
        }

        private void ICMPTest(int delay, object userState)
        {
            try
            {
                if (ip == null)
                {
                    ip = Dns.GetHostAddresses(server.server_ip)
                            .First(
                                ip =>
                                    ip.AddressFamily == AddressFamily.InterNetwork ||
                                    ip.AddressFamily == AddressFamily.InterNetworkV6);
                }
                repeat--;
                if (delay > 0)
                    Thread.Sleep(delay);
                ping.SendAsync(ip, TimeoutMilliseconds, userState);
            }
            catch (Exception e)
            {
                Logging.Error($"An exception occured while eveluating {server.FriendlyName()}");
                FireCompleted(e, userState);
            }
        }

        private void Ping_PingCompleted(object sender, PingCompletedEventArgs e)
        {
            try
            {
                if (e.Reply.Status == IPStatus.Success)
                {
                    RoundtripTime.Add((int?)e.Reply.RoundtripTime);
                }
                else
                {
                    RoundtripTime.Add(null);
                }
                TestNext(e.UserState);
            }
            catch (Exception ex)
            {
                Logging.Error($"An exception occured while eveluating {server.FriendlyName()}");
                FireCompleted(ex, e.UserState);
            }
        }

        private void TestNext(object userstate)
        {
            if (repeat > 0)
            {
                //Do ICMPTest in a random frequency
                int delay = TimeoutMilliseconds + new Random().Next() % TimeoutMilliseconds;
                new Task(() => ICMPTest(delay, userstate)).Start();
            }
            else
            {
                FireCompleted(null, userstate);
            }
        }

        private void FireCompleted(Exception error, object userstate)
        {
            Completed?.Invoke(this, new CompletedEventArgs
            {
                Error = error,
                Server = server,
                RoundtripTime = RoundtripTime,
                UserState = userstate
            });
        }

        public class CompletedEventArgs : EventArgs
        {
            public Exception Error;
            public AGService Server;
            public List<int?> RoundtripTime;
            public object UserState;
        }
    }
}
