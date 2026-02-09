using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using AppGo.Controller;
using AppGo.Model;
using AppGo.Util;
using System.Collections.Specialized;
using System.Net;
using System.Timers;
using System.Net.Http;
using Newtonsoft.Json;

namespace AppGo.View
{
    public partial class SignUpViewControl : BaseViewControl
    {
        private CountryListViewControl.CountrySelected CountrySelected;
        private CountryInfo SelectedCountry;
        private int SmSCounter = 120;
        System.Timers.Timer SmsTimer;

        public SignUpViewControl(AppGoViewController ViewController)
        {
            this.ViewController = ViewController;

            InitializeComponent();
            
            PasswordTextBox.SetUseSystemPasswordChar(true);
            
            ConfirmPasswordTextBox.SetUseSystemPasswordChar(true);
            
            CountrySelected = new CountryListViewControl.CountrySelected(OnCountrySelected);
        }

        protected override void UpdateUILanguage()
        {
            base.UpdateUILanguage();

            VerificationCodeButton.Text = LocalizationManager.GetString("verification code");
            TermsOfUseButton.Text = LocalizationManager.GetString("term of use");
            SignUpButton.Text = LocalizationManager.GetString("sign up");
            ContactUsButton.Text = LocalizationManager.GetString("contact us");
            AnyProblemsLabel.Text = LocalizationManager.GetString("already have id?");

            EmailAccountLabel.Text = LocalizationManager.GetString("email account");
            NicknameLabel.Text = LocalizationManager.GetString("nick name");
            PhoneNumberLabel.Text = LocalizationManager.GetString("phone number");
            VerificationCodeLabel.Text = LocalizationManager.GetString("verification code");
            PasswordLabel.Text = LocalizationManager.GetString("password");
            ConfirmPasswordLabel.Text = LocalizationManager.GetString("confirm password");

            EmailAccountTextBox.placeholder.Text = LocalizationManager.GetString("enter email account");
            NicknameTextBox.placeholder.Text = LocalizationManager.GetString("enter nick name");
            PhoneNumberTextBox.placeholder.Text = LocalizationManager.GetString("enter phone number");
            VerificationCodeTextBox.placeholder.Text = LocalizationManager.GetString("enter code");
            PasswordTextBox.placeholder.Text = LocalizationManager.GetString("enter password");
            ConfirmPasswordTextBox.placeholder.Text = LocalizationManager.GetString("enter password again");            
        }

        protected override bool ProcessCmdKey(ref Message msg, Keys keyData)
        {
            if (keyData == Keys.Enter)
            {
                SignUpButton.PerformClick();
                return true;
            }
            return base.ProcessCmdKey(ref msg, keyData);
        }

        private void OnCountrySelected(CountryInfo country)
        {
            SelectedCountry = country;
            PhoneNoPrefixButton.Text = SelectedCountry.PhoneCode;
        }

        private void SignUpButton_Click(object sender, EventArgs e)
        {
            if (!CheckInputs())
                return;

            SignupUser();
        }

        private void VerificationCodeButton_Click(object sender, EventArgs e)
        {
            if (PhoneNumberTextBox.Text.IsNullOrEmpty())
            {
                Utils.ShowMessageBox(LocalizationManager.GetString("please enter phone number."));
                return;
            }

            GetSmsCode();
        }

        private void PhoneNoPrefixButton_Click(object sender, EventArgs e)
        {
            ViewController.ShowCountryListView(CountrySelected, SelectedCountry);
        }

        private void BackButton_Click(object sender, EventArgs e)
        {
            ViewController.PopBackToPreviousView();
        }

        private void TermsOfUseButton_Click(object sender, EventArgs e)
        {
            ViewController.ShowTermsOfUseView();
        }

        private void ContactUsButton_Click(object sender, EventArgs e)
        {
            System.Diagnostics.Process proc = new System.Diagnostics.Process();
            proc.StartInfo.FileName = "mailto:" + AppInfo.emailAccount + "?subject=" + LocalizationManager.GetString("feedback description");
            proc.Start();
        }

        private bool CheckInputs()
        {
            bool result = false;

            string EmailAccount = EmailAccountTextBox.Text;
            string Nickname = NicknameTextBox.Text;
            string NativeNumber = PhoneNumberTextBox.Text;
            string PhoneNumber = PhoneNoPrefixButton.Text + NativeNumber;
            string Password = PasswordTextBox.Text;
            string ConfirmPassword = ConfirmPasswordTextBox.Text;

            if (EmailAccount.IsNullOrEmpty())
            {
                Utils.ShowMessageBox(LocalizationManager.GetString("please enter email account."));
            }
            else if (!Utils.IsValidEmailAddress(EmailAccount))
            {
                Utils.ShowMessageBox(LocalizationManager.GetString("the email account is invalid format."));
            }
            else if (Nickname.IsNullOrEmpty())
            {
                Utils.ShowMessageBox(LocalizationManager.GetString("please enter nick name."));
            }
            else if (PhoneNumber.IsNullOrEmpty())
            {
                Utils.ShowMessageBox(LocalizationManager.GetString("please enter phone number."));
            }
            else if (Password.IsNullOrEmpty())
            {
                Utils.ShowMessageBox(LocalizationManager.GetString("please enter password."));
            }
            else if (ConfirmPassword.IsNullOrEmpty())
            {
                Utils.ShowMessageBox(LocalizationManager.GetString("please enter password again."));
            }
            else if (Password != ConfirmPassword)
            {
                Utils.ShowMessageBox(LocalizationManager.GetString("please enter password correctly."));
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

        private async void GetSmsCode()
        {
            VerificationCodeButton.Enabled = false;

            string PhoneNumber = PhoneNoPrefixButton.Text + PhoneNumberTextBox.Text.Trim();

            try
            {
                var client = new HttpClient();
                Uri requestUri = API.Url("sms");

                client.DefaultRequestHeaders.Add("Accept", API.HEADER_ACCEPT);
                client.DefaultRequestHeaders.Add("Accept-Language", LocalizationManager.CurrentLanguage);
                //httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", "Your Oauth token");

                var parameters = new Dictionary<string, string>();
                parameters["mobile"] = PhoneNumber;
                parameters["for"] = "register";
                HttpContent content = new FormUrlEncodedContent(parameters);
                content.Headers.Add("Content-Language", LocalizationManager.CurrentLanguage);

                HttpResponseMessage response = await client.PostAsync(requestUri, content);
                string responJsonText = await response.Content.ReadAsStringAsync();
                if (Utils.StatusCode(response.StatusCode))
                {
                    var dict = JsonConvert.DeserializeObject<Dictionary<string, string>>(responJsonText);
                    SmSCounter = 120;
                    SmsTimer = new System.Timers.Timer();
                    SmsTimer.Elapsed += new ElapsedEventHandler(OnTimedEvent);
                    SmsTimer.Interval = 1000;
                    SmsTimer.Enabled = true;
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

        private void OnTimedEvent(object source, ElapsedEventArgs e)
        {
            if (SmSCounter <= 0)
            {
                SetSmsButtonState(LocalizationManager.GetString("verification code"), true);
                SmsTimer.Stop();
                SmsTimer = null;
            }
            else
            {
                SetSmsButtonState(SmSCounter + "s", false);
                SmSCounter--;
            }
        }

        delegate void SetSmsTextCallback(string text, bool enabled);
        private void SetSmsButtonState(string text, bool enabled)
        {
            // InvokeRequired required compares the thread ID of the
            // calling thread to the thread ID of the creating thread.
            // If these threads are different, it returns true.
            if (VerificationCodeButton.InvokeRequired)
            {
                SetSmsTextCallback d = new SetSmsTextCallback(SetSmsButtonState);
                this.Invoke(d, new object[] { text, enabled });
            }
            else
            {
                VerificationCodeButton.Enabled = enabled;
                VerificationCodeButton.Text = text;
            }
        }

        private async void SignupUser()
        {
            try
            {
                var client = new HttpClient();
                Uri requestUri = API.Url("register");

                client.DefaultRequestHeaders.Add("Accept", API.HEADER_ACCEPT);
                client.DefaultRequestHeaders.Add("Accept-Language", LocalizationManager.CurrentLanguage);
                //httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", "Your Oauth token");

                var parameters = new Dictionary<string, string>();
                parameters["email"] = EmailAccountTextBox.Text;
                parameters["mobile"] = PhoneNoPrefixButton.Text + PhoneNumberTextBox.Text.Trim();
                parameters["nickname"] = NicknameTextBox.Text;
                parameters["password"] = PasswordTextBox.Text;
                parameters["verify_code"] = VerificationCodeTextBox.Text;
                HttpContent content = new FormUrlEncodedContent(parameters);
                content.Headers.Add("Content-Language", LocalizationManager.CurrentLanguage);

                HttpResponseMessage response = await client.PostAsync(requestUri, content);
                string responJsonText = await response.Content.ReadAsStringAsync();
                if (Utils.StatusCode(response.StatusCode))
                {
                    ViewController.ShowLoginView();
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
