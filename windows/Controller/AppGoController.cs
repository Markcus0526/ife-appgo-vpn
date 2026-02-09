using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Threading;
using System.Web;

using AppGo.Model;
using AppGo.Util;
using System.Linq;

namespace AppGo.Controller
{
    public class AppGoController
    {
        private Thread ramThread;
        
        private AppPref config;
        private ProxyRunner proxyRunner = new ProxyRunner();
        private bool stopped = false;

        public class PathEventArgs : EventArgs
        {
            public string Path;
        }

        public class TrafficPerSecond
        {
            public long inboundCounter;
            public long outboundCounter;
            public long inboundIncreasement;
            public long outboundIncreasement;
        }

        public event EventHandler ConfigChanged;
        public event EventHandler EnableStatusChanged;
        public event EventHandler ShareOverLANStatusChanged;
        public event EventHandler VerboseLoggingStatusChanged;
        
        public event EventHandler ServiceChanged;
        public event EventHandler LaunchAtLoginChanged;
        public event EventHandler UserLanguageChanged;
        public event EventHandler LoginChanged;

        public event ErrorEventHandler Errored;

        public AppGoController()
        {
            config = AppPref.Load();
            
            StartReleasingMemory();
        }

        public void InitRunner()
        {
            proxyRunner.initRunner(config.firstRun);
            SeteFirstRun(false);
        }

        public bool Start()
        {
            ToggleEnable(false);            
            return Reload(false);
        }

        protected void ReportError(Exception e)
        {
            Errored(this, new ErrorEventArgs(e));
        }

        public AGService GetCurrentService()
        {
            return config.GetCurrentService();
        }

        // always return copy
        public AppPref GetConfigurationCopy()
        {
            return AppPref.Load();
        }

        // always return current instance
        public AppPref GetCurrentConfiguration()
        {
            return config;
        }
        
        public bool GeteFirstRun()
        {
            if (config.firstRun)
                return true;
            if (config.versionCode == "")
            {
                config.versionCode = AppInfo.Version.ToString();
                config.firstRun = true;
                return true;
            }
            float version = float.Parse(config.versionCode);
            if (version < AppInfo.Version)
            {
                config.versionCode = AppInfo.Version.ToString();
                config.firstRun = true;
                return true;
            }
            return config.firstRun;
        }

        public void SeteFirstRun(bool first)
        {
            config.firstRun = first;
            SaveConfig(config);
        }

        public void ToggleEnable(bool enabled)
        {
            if (config.enabled != enabled)
            {
                config.enabled = enabled;
                SaveConfig(config, true);

                EnableStatusChanged(this, new EventArgs());
            }            
        }

        public void SetPhoneNumber(string phoneNumber)
        {
            config.phoneNumber = phoneNumber;
            SaveConfig(config);
        }

        public void SetPassword(string password)
        {
            config.password = password;
            SaveConfig(config);
        }

        public void SetAccessToken(string accessToken)
        {
            config.accessToken = accessToken;
            SaveConfig(config);
        }

        public void SetRefreshToken(string refreshToken)
        {
            config.refreshToken = refreshToken;
            SaveConfig(config);
        }

        public void ClearUserInfo()
        {
            config.phoneNumber = "";
            config.password = "";
            config.accessToken = "";
            config.refreshToken = "";
            SaveConfig(config);
        }

        public bool IsLogined()
        {
            if (!config.phoneNumber.IsNullOrEmpty() && !config.password.IsNullOrEmpty())
                return true;
            else
                return false;
        }

        public void SetTokenType(string tokenType)
        {
            config.tokenType = tokenType;
            SaveConfig(config);
        }

        public void SetExpiresIn(int expiresIn)
        {
            config.expiresIn = expiresIn;
            SaveConfig(config);
        }
        public void SetLogined(bool login)
        {
            config.logined = login;
            SaveConfig(config);
        }
                
        public void SetServices(List<AGService> services)
        {
            config.services = services;
            SaveConfig(config);
        }

        public void ToggleLaunchAtLogin(bool enabled)
        {
            if (!AutoStartup.Set(enabled))
            {
                Utils.ShowMessageBox((LocalizationManager.GetString("can't connect to server.")));
                return;
            }

            LaunchAtLoginChanged(this, new EventArgs());
        }

        public void SetUserLanguage(string language)
        {
            LocalizationManager.CurrentLanguage = language;
            config.currentLanguage = language;
            SaveConfig(config);

            UserLanguageChanged(this, new EventArgs());
        }

        public void SetLoginChange(bool login)
        {
            config.logined = login;
            SaveConfig(config);

            LoginChanged(this, new EventArgs());
        }

        public void ToggleShareOverLAN(bool enabled)
        {
            config.shareOverLan = enabled;
            SaveConfig(config);

            ShareOverLANStatusChanged(this, new EventArgs());
        }
        
        public void ToggleVerboseLogging(bool enabled)
        {
            config.isVerboseLogging = enabled;
            SaveConfig(config);

            VerboseLoggingStatusChanged(this, new EventArgs());
        }

        public void SelectServerIndex(int index)
        {
            config.index = index;
            config.strategy = null;
            SaveConfig(config);

            ServiceChanged(this, new EventArgs());
        }

        public void SelectStrategy(string strategyID)
        {
            config.index = -1;
            config.strategy = strategyID;
            SaveConfig(config);
        }

        public bool Stop()
        {
            if (stopped)
                return true;
            
            stopped = true;
            return proxyRunner.Stop(true);
        }
   
        public string GetServerURLForCurrentServer()
        {
            AGService server = GetCurrentService();
            return GetServerURL(server);
        }

        public static string GetServerURL(AGService server)
        {
            string tag = string.Empty;
            string url = string.Empty;

            // For backwards compatiblity, if no plugin, use old url format
            string parts = $"{server.method}:{server.password}@{server.server_ip}:{server.server_port}";
            string base64 = Convert.ToBase64String(Encoding.UTF8.GetBytes(parts));
            url = base64;

            if (!server.remarks.IsNullOrEmpty())
            {
                tag = $"#{HttpUtility.UrlEncode(server.remarks, Encoding.UTF8)}";
            }
            return $"ss://{url}{tag}";
        }

        public bool Reload(bool enabled)
        {
            bool ret = false;
            try
            {
                // some logic in configuration updated the config when saving, we need to read it again
                config = AppPref.Load();
                
                if (!proxyRunner.Stop(true))
                    return false;
                
                if (enabled)
                    ret = proxyRunner.Start(config);            
            }
            catch (Exception e)
            {                
                Logging.Error(e);
                ReportError(e);
                return false;
            }

            ConfigChanged(this, new EventArgs());

            Utils.ReleaseMemory(true);
            return ret;
        }
        
        protected void SaveConfig(AppPref newConfig, bool IsReload = false)
        {
            AppPref.Save(newConfig);
            if (IsReload)
                Reload(newConfig.enabled);
        }
        
        private static readonly IEnumerable<char> IgnoredLineBegins = new[] { '!', '[' };
                
        #region Memory Management

        private void StartReleasingMemory()
        {
            ramThread = new Thread(new ThreadStart(ReleaseMemory));
            ramThread.IsBackground = true;
            ramThread.Start();
        }

        private void ReleaseMemory()
        {
            while (true)
            {
                Utils.ReleaseMemory(false);
                Thread.Sleep(30 * 1000);
            }
        }

        #endregion
    }
}
