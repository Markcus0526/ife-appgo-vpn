using System;
using System.Collections.Generic;
using System.Diagnostics;
using AppGo.Controller;
using AppGo.Model;
using Newtonsoft.Json;
using AppGo.Util;
using System.Net.Http;
using System.Net.Http.Headers;

namespace AppGo.View
{
    public partial class AccountViewControl : BaseViewControl
    {
        AGUser User = new AGUser();

        public AccountViewControl(AppGoViewController ViewController)
        {
            this.ViewController = ViewController;

            InitializeComponent();

            GetAccountInfo();
        }

        protected override void UpdateUILanguage()
        {
            base.UpdateUILanguage();

            TitleBarControl.Title = LocalizationManager.GetString("account");

            MiscellaneousLabel.Text = LocalizationManager.GetString("acoin");
            LevelLabel.Text = LocalizationManager.GetString("level");

            FeedbackButton.LabelText = LocalizationManager.GetString("feedback");
            AboutButton.LabelText = LocalizationManager.GetString("about");
            OfficialWebsiteButton.LabelText = LocalizationManager.GetString("website");
            ChangePasswordButton.LabelText = LocalizationManager.GetString("password");
            LogoutButton.LabelText = LocalizationManager.GetString("logout");
        }

        private void HelpButton_Click(object sender, EventArgs e)
        {
            ViewController.ShowNotificationView();
        }

        private void FeedbackButton_Click(object sender, EventArgs e)
        {
            System.Diagnostics.Process proc = new System.Diagnostics.Process();
            proc.StartInfo.FileName = "mailto:" + AppInfo.emailAccount + "?subject=" + LocalizationManager.GetString("feedback description");
            proc.Start();
        }

        private void OfficialWebsiteButton_Click(object sender, EventArgs e)
        {
            Process.Start(AppInfo.websiteUrl);
        }

        private void AboutButton_Click(object sender, EventArgs e)
        {
            ViewController.ShowAboutUsView();
        }

        private void ChangePasswordButton_Click(object sender, EventArgs e)
        {
            ViewController.ShowForgotPasswordView(true);
        }

        private void LogoutButton_Click(object sender, EventArgs e)
        {
            ViewController.Controller.ToggleEnable(false);

            ViewController.Controller.ClearUserInfo();
            ViewController.Controller.SetLoginChange(false);

            ViewController.ShowLoginView();
        }

        private async void GetAccountInfo()
        {
            try
            {
                var client = new HttpClient();
                Uri requestUri = API.Url("user");

                client.DefaultRequestHeaders.Add("Accept", API.HEADER_ACCEPT);
                client.DefaultRequestHeaders.Add("Accept-Language", LocalizationManager.CurrentLanguage);
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", ViewController.Controller.GetCurrentConfiguration().accessToken);

                HttpResponseMessage response = await client.GetAsync(requestUri);
                string responJsonText = await response.Content.ReadAsStringAsync();
                if (Utils.StatusCode(response.StatusCode))
                {
                    var user = JsonConvert.DeserializeObject<AGUser>(responJsonText);
                    UsernameLabel.Text = user.nickname;
                    PhoneNumberLabel.Text = Utils.GetNativePhoneNumber(user.mobile);
                    LevelValueButton.Text = "LV." + user.level.ToString();
                    MiscellaneousLabel.Text += " " + user.acoin.ToString();
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
