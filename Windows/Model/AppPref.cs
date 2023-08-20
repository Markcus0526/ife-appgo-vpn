using System;
using System.Collections.Generic;
using System.IO;
using AppGo.Util;

using AppGo.Controller;
using Newtonsoft.Json;

namespace AppGo.Model
{
    public class AppPref
    {
        public List<AGService> services;

        public bool enabled;
        

        // when strategy is set, index is ignored
        public string strategy;
        public int index;
        
        public bool shareOverLan;
        public bool isDefault;
        public int localPort;
        public bool portableMode = true;
        public string pacUrl;
        public bool useOnlinePac;
        public bool secureLocalPac = true;
        public bool availabilityStatistics;
        public bool isVerboseLogging;
        
        private static string CONFIG_FILE = "appgo-config.bin";
        private static string CRYPT_KEY = "AppGo2018";

        public string phoneNumber = "";
        public string password = "";
        public string tokenType = "";
        public string accessToken = "";
        public int expiresIn = 0;
        public string refreshToken = "";
        public string loginDate;
        public string ruleMode = VPNRule.GLOBAL;
        public string currentLanguage = LocalizationManager.English;
        public bool logined = false;
        public bool firstRun = true;
        public string versionCode = "";
        

        public AGService GetCurrentService()
        {
            if (services != null && index >= 0 && index < services.Count)
                return services[index];
            return null;
        }

        public static void CheckService(AGService server)
        {
            CheckPort(server.server_port);
            CheckPassword(server.password);
            CheckService(server.server_ip);
            CheckTimeout(server.timeout, AGService.MaxServerTimeoutSec);
        }

        public static AppPref Load()
        {
            try
            {
                string FilePath = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), CONFIG_FILE);
                string EncryptString = File.ReadAllText(FilePath);
                string ConfigContent = Util.StringCipher.Decrypt(EncryptString, CRYPT_KEY);
                AppPref config = JsonConvert.DeserializeObject<AppPref>(ConfigContent);
                config.isDefault = false;

                if (config.services == null)
                {
                    config.services = new List<AGService>();
                }
                if (config.localPort == 0)
                    config.localPort = 1084;
                if (config.index == -1 && config.strategy == null)
                    config.index = 0;
                if (config.currentLanguage.IsNullOrEmpty())
                    config.currentLanguage = LocalizationManager.Chinese;
                
                return config;
            }
            catch (Exception e)
            {
                if (!(e is FileNotFoundException))
                    Logging.Error(e);
                return new AppPref();                
            }
        }

        public static void Save(AppPref config)
        {
            /*if (config.index >= config.servers.Count)
                config.index = config.servers.Count - 1;
            if (config.index < -1)
                config.index = -1;
            if (config.index == -1 && config.strategy == null)
                config.index = 0;*/
            config.isDefault = false;
            try
            {
                string FilePath = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), CONFIG_FILE);
                using (StreamWriter sw = new StreamWriter(File.Open(FilePath, FileMode.Create)))
                {
                    string JsonString = JsonConvert.SerializeObject(config, Formatting.Indented);
                    string EncryptString = Util.StringCipher.Encrypt(JsonString, CRYPT_KEY);
                    sw.Write(EncryptString);
                    sw.Flush();
                }
            }
            catch (IOException e)
            {
                Logging.Error(e);
            }
        }

        private static void Assert(bool condition)
        {
            if (!condition)
                throw new Exception(LocalizationManager.GetString("assertion failure"));
        }

        public static void CheckPort(int port)
        {
            if (port <= 0 || port > 65535)
                throw new ArgumentException(LocalizationManager.GetString("Port out of range"));
        }
        
        private static void CheckPassword(string password)
        {
            if (password.IsNullOrEmpty())
                throw new ArgumentException(LocalizationManager.GetString("Password can not be blank"));
        }

        public static void CheckService(string server)
        {
            if (server.IsNullOrEmpty())
                throw new ArgumentException(LocalizationManager.GetString("Server IP can not be blank"));
        }

        public static void CheckTimeout(int timeout, int maxTimeout)
        {
            if (timeout <= 0 || timeout > maxTimeout)
                throw new ArgumentException(string.Format(
                    LocalizationManager.GetString("Timeout is invalid, it should not exceed {0}"), maxTimeout));
        }
    }

    public class AppInfo
    {
        public static float Version = 1.4f;
                
        public static string emailAccount = "appgohk@gmail.com";
        public static string twitterUrl = "https://twitter.com/appgohk";
        public static string telegramUrl = "https://t.me/appgo";
        public static string alipayUrl = "http://mediabiu.com/";
        public static string websiteUrl = "https://app135.com";
    }
}
