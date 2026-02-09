using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AppGo.Model
{
    [Serializable]
    class AGAboutus
    {
        [JsonProperty("content")]
        public string content { get; set; } = "";
    }
}
