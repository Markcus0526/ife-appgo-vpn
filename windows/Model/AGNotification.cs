using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AppGo.Model
{
    [Serializable]
    public class AGNotificationData
    {
        [JsonProperty("id")]
        public int id { get; set; } = 0;

        [JsonProperty("title")]
        public string title { get; set; } = "";

        [JsonProperty("content")]
        public string content { get; set; } = "";

        [JsonProperty("updated_at")]
        public string updated_at { get; set; } = "";
    }

    [Serializable]
    public class AGNotification
    {
        [JsonProperty("per_page")]
        public int per_page { get; set; } = 0;

        [JsonProperty("current_page")]
        public int current_page { get; set; } = 0;

        [JsonProperty("next_page_url")]
        public string next_page_url { get; set; } = "";

        [JsonProperty("prev_page_url")]
        public string prev_page_url { get; set; } = "";

        [JsonProperty("from")]
        public string from { get; set; } = "";

        [JsonProperty("to")]
        public string to { get; set; } = "";

        [JsonProperty("data")]
        public List<AGNotificationData> data { get; set; } = new List<AGNotificationData>();
    }
}
