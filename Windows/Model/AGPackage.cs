using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AppGo.Model
{
   [Serializable]
    public class AGPackage
    {
        [JsonProperty("id")]
        public int id { get; set; } = 0;

        [JsonProperty("duration")]
        public int duration { get; set; } = 0;

        [JsonProperty("price")]
        public int price { get; set; } = 0;

        [JsonProperty("transfer")]
        public long transfer { get; set; } = 0;

        [JsonProperty("apple_product_id")]
        public string apple_product_id { get; set; } = "";
    }
}
