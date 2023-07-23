using System.Collections.Generic;
using System.IO;
using AppGo.Model;
using AppGo.Util;

namespace AppGo.Controller
{
    using Properties;

    public static class LocalizationManager
    {
        public const string English = "US";
        public const string Chinese = "CN";

        private static Dictionary<string, string> _strings = new Dictionary<string, string>();

        private static void Init(string res)
        {
            _strings.Clear();

            using (var sr = new StringReader(res))
            {
                foreach (var line in sr.NonWhiteSpaceLines())
                {
                    if (line[0] == '#')
                        continue;

                    var pos = line.IndexOf('=');
                    if (pos < 1)
                        continue;
                    _strings[line.Substring(0, pos)] = line.Substring(pos + 1);
                }
            }
        }

        static LocalizationManager()
        {
            Reload();
        }

        public static string CurrentLanguage
        {
            get
            {
                return AppPref.Load().currentLanguage;
            }
            set
            {
                AppPref config = AppPref.Load();
                config.currentLanguage = value;
                AppPref.Save(config);
                Reload();
            }
        }

        private static void Reload()
        {
            if (CurrentLanguage.Equals(Chinese))
            {
                Init(Resources.Chinese);
            }
            else
            {
                Init(Resources.English);
            }
        }

        public static string GetString(string key)
        {
            return _strings.ContainsKey(key) ? _strings[key] : key;
        }
    }
}
