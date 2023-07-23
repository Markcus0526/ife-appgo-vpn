using System;
using System.Diagnostics;
using AppGo.Controller;
using AppGo.Model;
using System.IO;
using System.Collections.Specialized;
using Newtonsoft.Json;
using System.Net;
using AppGo.Util;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Dynamic;
using System.Collections.Generic;
using System.Text;

namespace AppGo.View
{
    public partial class AboutUsViewControl : BaseViewControl
    {
        public AboutUsViewControl(AppGoViewController ViewController)
        {
            this.ViewController = ViewController;

            InitializeComponent();

            GetAboutInfo();
        }

        protected override void UpdateUILanguage()
        {
            base.UpdateUILanguage();

            AppGoTitleLabel.Text = LocalizationManager.GetString("app version");
            AboutUsTitleLabel.Text = LocalizationManager.GetString("aboutus");
            CopyrightLabel.Text = LocalizationManager.GetString("all rights");

            FollowOnTwitterButton.Text = LocalizationManager.GetString("twitter");
        }

        private void BackButton_Click(object sender, EventArgs e)
        {
            ViewController.PopBackToPreviousView();
        }

        private void FollowOnTwitterButton_Click(object sender, EventArgs e)
        {
            Process.Start(AppInfo.twitterUrl);
        }

        private async void GetAboutInfo()
        {
            try
            {
                var client = new HttpClient();
                Uri requestUri = API.Url("aboutus");

                client.DefaultRequestHeaders.Add("Accept", API.HEADER_ACCEPT);                
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", ViewController.Controller.GetCurrentConfiguration().accessToken);

                var payload = "{\"get\": 1}";
                HttpContent content = new StringContent(payload);
                HttpRequestMessage httpMsg = new HttpRequestMessage(HttpMethod.Post, "Api/FileHandler");
                content.Headers.Add("Content-Language", LocalizationManager.CurrentLanguage);

                HttpResponseMessage response = await client.GetAsync(requestUri);
                string responJsonText = await response.Content.ReadAsStringAsync();                
                if (Utils.StatusCode(response.StatusCode))
                {
                    var aboutus = JsonConvert.DeserializeObject<AGAboutus>(responJsonText);
                    string Desc = aboutus.content.Replace("\n", "\r\n");
                    aboutUsContentLabel.Text = Desc;
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
