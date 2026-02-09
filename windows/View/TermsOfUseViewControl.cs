using System;
using System.Collections.Generic;
using AppGo.Controller;
using AppGo.Model;
using System.Net;
using AppGo.Util;
using Newtonsoft.Json;
using System.Net.Http;

namespace AppGo.View
{
    public partial class TermsOfUseViewControl : BaseViewControl
    {
        public TermsOfUseViewControl(AppGoViewController ViewController)
        {
            this.ViewController = ViewController;

            InitializeComponent();

            GetTermInfo();
        }
        
        protected override void UpdateUILanguage()
        {
            base.UpdateUILanguage();

            TitleBarControl.Title = LocalizationManager.GetString("term of use");
        }

        private async void GetTermInfo()
        {
            try
            {
                var client = new HttpClient();
                Uri requestUri = API.Url("tos");

                client.DefaultRequestHeaders.Add("Accept", API.HEADER_ACCEPT);
                client.DefaultRequestHeaders.Add("Accept-Language", LocalizationManager.CurrentLanguage);
                
                HttpResponseMessage response = await client.GetAsync(requestUri);
                string responJsonText = await response.Content.ReadAsStringAsync();
                if (Utils.StatusCode(response.StatusCode))
                {
                    var content = JsonConvert.DeserializeObject<Dictionary<string, string>>(responJsonText);
                    string desc = content["content"].Replace("\n", "\r\n");
                    ContentTextBox.Text = desc;                    
                }
                else
                {
                    var error = JsonConvert.DeserializeObject<Dictionary<string, string>>(responJsonText);
                    Utils.ShowMessageBox(error["message"]);
                }
            }
            catch (Exception e)
            {
                Utils.ShowMessageBox(LocalizationManager.GetString("can't connect to server."));
            }            
        }
    }
}
