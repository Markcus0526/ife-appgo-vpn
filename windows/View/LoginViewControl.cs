using System;
using System.Diagnostics;
using AppGo.Controller;
using AppGo.Model;
using AppGo.Util;
using System.Collections.Generic;
using Newtonsoft.Json;
using System.Collections.Specialized;
using System.Net;
using System.Windows.Forms;
using System.Net.Http;
using System.Dynamic;
using System.Net.Http.Headers;
using System.Text;

namespace AppGo.View
{
    public partial class LoginViewControl : BaseViewControl
    {
        private CountryListViewControl.CountrySelected CountrySelected;
        private CountryInfo SelectedCountry;
        
        public LoginViewControl(AppGoViewController ViewController)
        {
            this.ViewController = ViewController;

            InitializeComponent();

            UserNameTextBox.SetLeftPadding(PhoneNoPrefixButton.Size.Width + 30);
            PasswordTextBox.SetLeftPadding(30);
            PasswordTextBox.SetUseSystemPasswordChar(true);

            CountrySelected = new CountryListViewControl.CountrySelected(OnCountrySelected);
        }

        protected override void UpdateUILanguage()
        {
            base.UpdateUILanguage();

            SignInButton.Text = LocalizationManager.GetString("sign in");
            UserNameTextBox.PlaceholderText = LocalizationManager.GetString("enter phone number");
            PasswordTextBox.PlaceholderText = LocalizationManager.GetString("enter password");
            ForgotPasswordButton.Text = LocalizationManager.GetString("forgot password");
            SignUpButton.Text = LocalizationManager.GetString("register now");
            SloganLabel.Text = LocalizationManager.GetString("stable service and speed, give you a different experience");
        }

        protected override bool ProcessCmdKey(ref Message msg, Keys keyData)
        {
            if (keyData == Keys.Enter)
            {
                SignInButton.PerformClick();
                return true;
            }
            return base.ProcessCmdKey(ref msg, keyData);
        }

        private void OnCountrySelected(CountryInfo country)
        {
            SelectedCountry = country;
            PhoneNoPrefixButton.Text = country.PhoneCode;
        }

        private void SignInButton_Click(object sender, EventArgs e)
        {
            if (!CheckInputs())
                return;

            LoginUser();       
        }

        private void ForgotPasswordButton_Click(object sender, EventArgs e)
        {
            ViewController.ShowForgotPasswordView();
        }

        private void SignUpButton_Click(object sender, EventArgs e)
        {
            ViewController.ShowSignUpView();
        }

        private void TwitterButton_Click(object sender, EventArgs e)
        {
            Process.Start(AppInfo.twitterUrl);
        }

        private void EmailButton_Click(object sender, EventArgs e)
        {
            Process.Start("mailto:" + AppInfo.emailAccount);
        }

        private void TelegramButton_Click(object sender, EventArgs e)
        {
            Process.Start(AppInfo.websiteUrl);
        }

        private void MinimizeButton_Click(object sender, EventArgs e)
        {
            ViewController.MinimizeMainForm();
        }

        private void CloseButton_Click(object sender, EventArgs e)
        {
            ViewController.CloseMainForm();
        }

        private void PhoneNoPrefixButton_Click(object sender, EventArgs e)
        {
            ViewController.ShowCountryListView(CountrySelected, SelectedCountry);
        }

        private bool CheckInputs()
        {
            bool result = false;

            // field verification
            string PhoneNumber = UserNameTextBox.Text.Trim();
            string Password = PasswordTextBox.Text.Trim();

            if (PhoneNumber.IsNullOrEmpty())
            {
                Utils.ShowMessageBox(LocalizationManager.GetString("please enter phone number."));
            }
            else if (Password.IsNullOrEmpty())
            {
                Utils.ShowMessageBox(LocalizationManager.GetString("please enter password."));
            }
            else if (Password.Length < 6)
            {
                Utils.ShowMessageBox(LocalizationManager.GetString("the password must be at least 6 characters."));
            }
            else
            {
                result = true;
            }

            return result;
        }

        private async void LoginUser()
        {
            SignInButton.Enabled = false;

            try
            {
                var client = new HttpClient();                
                Uri requestUri = API.Url("login");
                
                client.DefaultRequestHeaders.Add("Accept", API.HEADER_ACCEPT);
                                
                var parameters = new Dictionary<string, string>();
                parameters["username"] = PhoneNoPrefixButton.Text + UserNameTextBox.Text.Trim();
                parameters["password"] = PasswordTextBox.Text.Trim();
                parameters["client_id"] = API.CLIENT_ID;
                parameters["client_secret"] = API.CLIENT_SECRET;
                parameters["grant_type"] = "password";

                HttpContent content = new FormUrlEncodedContent(parameters);
                content.Headers.Add("Content-Language", LocalizationManager.CurrentLanguage);                
                HttpResponseMessage response = await client.PostAsync(requestUri, content);
                string responJsonText = await response.Content.ReadAsStringAsync();                
                if (Utils.StatusCode(response.StatusCode))
                {
                    var dict = JsonConvert.DeserializeObject<Dictionary<string, string>>(responJsonText);
                    ViewController.Controller.SetPhoneNumber(PhoneNoPrefixButton.Text + UserNameTextBox.Text.Trim());
                    ViewController.Controller.SetPassword(PasswordTextBox.Text.Trim());
                    ViewController.Controller.SetTokenType(dict["token_type"]);
                    ViewController.Controller.SetAccessToken(dict["access_token"]);
                    ViewController.Controller.SetExpiresIn(int.Parse(dict["expires_in"]));
                    ViewController.Controller.SetRefreshToken(dict["refresh_token"]);
                    ViewController.Controller.SetServices(null);

                    ViewController.Controller.SetLoginChange(true);

                    ViewController.ShowMainView();
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

            SignInButton.Enabled = true;           
        }
    }
}
