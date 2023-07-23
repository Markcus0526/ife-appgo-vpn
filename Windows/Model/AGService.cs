using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Text;
using System.Web;
using AppGo.Controller;
using AppGo.Util;
using System.Text.RegularExpressions;
using Newtonsoft.Json;

namespace AppGo.Model
{
    [Serializable]
    public class AGService
    {
        #region ParseLegacyURL
        public static readonly Regex
            UrlFinder = new Regex(@"ss://(?<base64>[A-Za-z0-9+-/=_]+)(?:#(?<tag>\S+))?", RegexOptions.IgnoreCase),
            DetailsParser = new Regex(@"^((?<method>.+?):(?<password>.*)@(?<hostname>.+?):(?<port>\d+?))$", RegexOptions.IgnoreCase);
        #endregion ParseLegacyURL

        private const int DefaultServerTimeoutSec = 5;
        public const int MaxServerTimeoutSec = 20;

        [JsonProperty("country")]
        public AGCountry country { get; set; } = new AGCountry();

        [JsonProperty("ip")]
        public string server_ip { get; set; } = "";

        [JsonProperty("port")]
        public int server_port;

        [JsonProperty("passwd")]
        public string password { get; set; } = "";

        [JsonProperty("method")]
        public string method {get; set; } = "rc4-md5";

        [JsonProperty("transfer_enable")]
        public long transfer_enable { get; set; } = 0;

        [JsonProperty("upload")]
        public long upload { get; set; } = 0;

        [JsonProperty("download")]
        public long download { get; set; } = 0;

        [JsonProperty("expire_time")]
        public DateTime expire_time { get; set; } = DateTime.Now;

        public string remarks { get; set; } = "";
        public int timeout;
        //public bool qr_code { get; set; } = false;
        //public int country_id { get; set; } = 0;
        //public string country_name{ get; set; } = "";
        //public string country_alias_en { get; set; } = "";
        //public string country_alias_zh { get; set; } = "";
        
        
        public int delay { get; set; } = 0;

        public override int GetHashCode()
        {
            return server_ip.GetHashCode() ^ server_port;
        }

        /*public override bool Equals(object obj)
        {
            AGService o2 = (AGService)obj;
            return server_ip == o2.server_ip && server_port == o2.server_port;
        }*/

        public string FriendlyName()
        {
            if (server_ip.IsNullOrEmpty())
            {
                return LocalizationManager.GetString("New server");
            }

            string serverStr = $"{FormatHostName(server_ip)}:{server_port}";
            if (!country.name.IsNullOrEmpty())
            {
                string countryFullName = CountryTemplate.GetCountryName(country.name);
                return $"{countryFullName}";
            }
            else if (!remarks.IsNullOrEmpty())
            {
                return $"{remarks} ({serverStr})";
            }
            else
            {
                return serverStr;
            }
        }

        public string FormatHostName(string hostName)
        {
            // CheckHostName() won't do a real DNS lookup
            switch (Uri.CheckHostName(hostName))
            {
                case UriHostNameType.IPv6:  // Add square bracket when IPv6 (RFC3986)
                    return $"[{hostName}]";
                default:    // IPv4 or domain name
                    return hostName;
            }
        }

        public AGService()
        {
            server_ip = "";
            server_port = 8388;
            method = "aes-256-cfb";
            password = "";
            remarks = "";
            timeout = DefaultServerTimeoutSec;            
        }
    }
}
