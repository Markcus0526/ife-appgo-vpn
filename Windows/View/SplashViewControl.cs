using System;
using System.Collections.Generic;
using System.Windows.Forms;
using AppGo.Controller;
using System.IO;
using AppGo.Model;
using System.Net;
using AppGo.Util;
using Newtonsoft.Json;
using System.Net.Http;
using System.Threading;

namespace AppGo.View
{
    public partial class SplashViewControl : BaseViewControl
    {
        private Thread initThread;
        private delegate void FinishDelegate(int state);

        public SplashViewControl(AppGoViewController viewController)
        {
            this.ViewController = viewController;

            InitializeComponent();            
        }
        
        protected override void UpdateUILanguage()
        {
            base.UpdateUILanguage();

            InitLabel.Text = LocalizationManager.GetString("initializing");
        }

        private void SplashViewControl_Load(object sender, EventArgs e)
        {
            if (ViewController.Controller.GeteFirstRun())
                InitLabel.Show();

            initThread = new Thread(new ThreadStart(this.InitThreadProc));
            initThread.Start();
        }

        private void FinishSplash(int state)
        {
            if (this.InvokeRequired)
                this.Invoke(new FinishDelegate(this.FinishSplash), state);
            else
            {
                if (state == 1)
                    ViewController.ShowMainView();                
                else if (state == 2)
                    ViewController.ShowLoginView();                
                else
                {
                    DialogResult ret = Utils.ShowMessageBox(LocalizationManager.GetString("can't connect to server."));
                    Application.Exit();
                }                    
            }
        }

        private void InitThreadProc()
        {   
            GetBaseUrl();
        }

        private async void GetBaseUrl()
        {
            try
            {
                HttpWebRequest request = WebRequest.Create(API.BASE_URL) as HttpWebRequest;
                using (HttpWebResponse resp = request.GetResponse() as HttpWebResponse)
                {
                    StreamReader reader = new StreamReader(resp.GetResponseStream());
                    API.SERVICE_URL = reader.ReadToEnd().Replace("\n", "");

                    GetVersionInfo();
                    ViewController.Controller.InitRunner();
                    ViewController.Controller.ToggleEnable(false);

                    AppPref config = ViewController.Controller.GetConfigurationCopy();
                    if (!config.logined)
                    {
                        FinishSplash(2);
                    }

                    if (config.phoneNumber.IsNullOrEmpty() || config.password.IsNullOrEmpty())
                    {
                        FinishSplash(2);
                    }

                    try
                    {
                        var client = new HttpClient();
                        Uri requestUri = API.Url("login");

                        client.DefaultRequestHeaders.Add("Accept", API.HEADER_ACCEPT);
                        client.DefaultRequestHeaders.Add("Accept-Language", LocalizationManager.CurrentLanguage);

                        var parameters = new Dictionary<string, string>();
                        parameters["username"] = config.phoneNumber;
                        parameters["password"] = config.password;
                        parameters["client_id"] = API.CLIENT_ID;
                        parameters["client_secret"] = API.CLIENT_SECRET;
                        parameters["grant_type"] = "password";
                        HttpContent content = new FormUrlEncodedContent(parameters);
                        content.Headers.Add("Content-Language", LocalizationManager.CurrentLanguage);

                        HttpResponseMessage response = await client.PostAsync(requestUri, content);
                        var responJsonText = response.Content.ReadAsStringAsync();
                        if (Utils.StatusCode(response.StatusCode))
                        {
                            var dict = JsonConvert.DeserializeObject<Dictionary<string, string>>(responJsonText.Result);
                            ViewController.Controller.SetTokenType(dict["token_type"]);
                            ViewController.Controller.SetAccessToken(dict["access_token"]);
                            ViewController.Controller.SetExpiresIn(int.Parse(dict["expires_in"]));
                            ViewController.Controller.SetRefreshToken(dict["refresh_token"]);

                            ViewController.Controller.SetLoginChange(true);

                            FinishSplash(1);
                        }                        
                    }
                    catch (Exception e)
                    {
                        Logging.Error(e);
                        FinishSplash(2);
                    }
                }
            }
            catch (Exception e)
            {
                Logging.Error(e);
                FinishSplash(3);
            }
            
        }

        private async void GetVersionInfo()
        {
            try
            {
                var client = new HttpClient();
                Uri requestUri = API.Url("app/version?platform=Windows");
                //Uri requestUri = new Uri("https://dev.yeseji.com/app/version?platform=Windows");

                client.DefaultRequestHeaders.Add("Accept", API.HEADER_ACCEPT);
                client.DefaultRequestHeaders.Add("Accept-Language", LocalizationManager.CurrentLanguage);
                
                HttpResponseMessage response = await client.GetAsync(requestUri);
                string responJsonText = await response.Content.ReadAsStringAsync();
                if (Utils.StatusCode(response.StatusCode))
                {
                    var dict = JsonConvert.DeserializeObject<Dictionary<string, string>>(responJsonText);
                    if (AppInfo.Version < float.Parse(dict["version"].ToString()))
                    {
                        var result = Utils.ShowYesNoMessageBox(this.ParentForm, LocalizationManager.GetString("new version is available.please update now."));
                        if (result == DialogResult.OK)
                        {
                            string TargetURL = (string)dict["link"];
                            System.Diagnostics.Process.Start(TargetURL);
                        }
                    }
                }                
            }
            catch (Exception e)
            {                
            }
        }
    }
}
