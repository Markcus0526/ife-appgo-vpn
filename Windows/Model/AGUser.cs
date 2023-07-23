using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AppGo.Model
{
    [Serializable]
    class AGUser
    {
        [JsonProperty("id")]
        public int id { get; set; } = 0;

        [JsonProperty("level")]
        public int level { get; set; } = 0;

        [JsonProperty("mobile")]
        public String mobile { get; set; } = "";

        [JsonProperty("nickname")]
        public String nickname { get; set; } = "";

        [JsonProperty("mailaccount")]
        public String mailaccount { get; set; } = "";

        [JsonProperty("acoin")]
        public int acoin { get; set; } = 0;

        [JsonProperty("createdat")]
        public String createdat { get; set; } = "";
    }
}
