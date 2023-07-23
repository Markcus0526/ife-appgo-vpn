using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AppGo.Model
{
    [Serializable]
    public class AGCountry
    {
        [JsonProperty("id")]
        public int id { get; set; } = 0;

        [JsonProperty("name")]
        public string name { get; set; } = "";

        [JsonProperty("alias_zh")]
        public string alias_zh { get; set; } = "";

        [JsonProperty("alias_en")]
        public string alias_en { get; set; } = "";

        [JsonProperty("description")]
        public string description { get; set; } = "";
    }
}
