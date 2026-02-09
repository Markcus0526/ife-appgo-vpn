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
using Newtonsoft.Json;
using System.Timers;
using System.Net.Http;
using System.Dynamic;

namespace AppGo.View
{
    public partial class ForgotPasswordViewControl : BaseViewControl
    {
        private bool ModifyMode = false;
        private CountryListViewControl.CountrySelected CountrySelected;
        private CountryInfo SelectedCountry;
        private int SmSCounter = 120;
        System.Timers.Timer SmsTimer;

        
        public ForgotPasswordViewControl(AppGoViewController ViewController, bool ModifyMode)
        {
            this.ViewController = ViewController;
            this.ModifyMode = ModifyMode;            

            InitializeComponent();

            NewPasswordTextBox.SetUseSystemPasswordChar(true);
            ConfirmPasswordTextBox.SetUseSystemPasswordChar(true);            

            CountrySelected = new CountryListViewControl.CountrySelected(OnCountrySelected);
        }

        private void ForgotPasswordViewControl_Load(object sender, EventArgs e)
        {
            if (ModifyMode)
            {
                AppPref config = ViewController.Controller.GetConfigurationCopy();
                PhoneNoPrefixButton.Text = Utils.GetPhoneCountryCode(config.phoneNumber);
                PhoneNumberTextBox.Text = Utils.GetNativePhoneNumber(config.phoneNumber);
                PhoneNoPrefixButton.Enabled = false;
                PhoneNumberTextBox.Enabled = false;
            }
        }

        protected override void UpdateUILanguage()
        {
            base.UpdateUILanguage();

            VerificationCodeButton.Text = LocalizationManager.GetString("verification code");
            ResetPasswordButton.Text = LocalizationManager.GetString("reset password");

            PhoneNumberLabel.Text = LocalizationManager.GetString("phone number");
            VerificationCodeLabel.Text = LocalizationManager.GetString("verification code");
            NewPasswordLabel.Text = LocalizationManager.GetString("new password");
            ConfirmPasswordLabel.Text = LocalizationManager.GetString("confirm password");

            PhoneNumberTextBox.placeholder.Text = LocalizationManager.GetString("enter phone number");
            VerificationCodeTextBox.placeholder.Text = LocalizationManager.GetString("enter code");
            NewPasswordTextBox.placeholder.Text = LocalizationManager.GetString("enter new password");
            ConfirmPasswordTextBox.placeholder.Text = LocalizationManager.GetString("enter new password again");
        }

        protected override bool ProcessCmdKey(ref Message msg, Keys keyData)
        {
            if (keyData == Keys.Enter)
            {
                ResetPasswordButton.PerformClick();
                return true;
            }
            return base.ProcessCmdKey(ref msg, keyData);
        }


        private void OnCountrySelected(CountryInfo country)
        {
            SelectedCountry = country;
            PhoneNoPrefixButton.Text = country.PhoneCode;
        }

        

        private void ResetPasswordButton_Click(object sender, EventArgs e)
        {
            if (!CheckInputs())
                return;

            UpdatePassword();
        }

        private void VerificationCodeButton_Click(object sender, EventArgs e)
        {
            if (!ModifyMode && PhoneNumberTextBox.Text.IsNullOrEmpty())
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

        private bool CheckInputs()
        {
            bool result = false;

            // field verification
            string NewPassword = NewPasswordTextBox.Text;
            string ConfirmPassword = ConfirmPasswordTextBox.Text;

            if (NewPassword.IsNullOrEmpty())
            {
                Utils.ShowMessageBox(LocalizationManager.GetString("please enter new password."));
            }
            else if (ConfirmPassword.IsNullOrEmpty())
            {
                Utils.ShowMessageBox(LocalizationManager.GetString("please enter new password again."));
            }
            else if (NewPassword.Length <  6 || ConfirmPassword.Length < 6)
            {
                Utils.ShowMessageBox(LocalizationManager.GetString("the password must be at least 6 characters."));
            }
            else if (NewPassword != ConfirmPassword)
            {
                Utils.ShowMessageBox(LocalizationManager.GetString("please enter password correctly."));
            }
            else {
                result = true;
            }

            return result;
        }

        private async void GetSmsCode()
        {
            VerificationCodeButton.Enabled = false;

            string PhoneNumber = PhoneNoPrefixButton.Text + PhoneNumberTextBox.Text.Trim();
            if (ModifyMode)
            {
                AppPref config = ViewController.Controller.GetConfigurationCopy();
                PhoneNumber = config.phoneNumber;             
            }

            try
            {
                var client = new HttpClient();
                Uri requestUri = API.Url("sms");

                client.DefaultRequestHeaders.Add("Accept", API.HEADER_ACCEPT);
                client.DefaultRequestHeaders.Add("Accept-Language", LocalizationManager.CurrentLanguage);
                
                var parameters = new Dictionary<string, string>();                
                parameters["mobile"] = PhoneNumber;
                parameters["for"] = "resetPassword";
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

        private async void UpdatePassword()
        {
            ResetPasswordButton.Enabled = false;

            string PhoneNumber = PhoneNoPrefixButton.Text + PhoneNumberTextBox.Text.Trim();
            if (ModifyMode)
            {
                AppPref config = ViewController.Controller.GetConfigurationCopy();
                PhoneNumber = config.phoneNumber;
            }

            try
            {
                var client = new HttpClient();
                Uri requestUri = API.Url("password");

                client.DefaultRequestHeaders.Add("Accept", API.HEADER_ACCEPT);
                client.DefaultRequestHeaders.Add("Accept-Language", LocalizationManager.CurrentLanguage);
                //httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", "Your Oauth token");

                var parameters = new Dictionary<string, string>();
                parameters["mobile"] = PhoneNumber;
                parameters["new_password"] = NewPasswordTextBox.Text;
                parameters["verify_code"] = VerificationCodeTextBox.Text;
                HttpContent content = new FormUrlEncodedContent(parameters);
                content.Headers.Add("Content-Language", LocalizationManager.CurrentLanguage);

                HttpResponseMessage response = await client.PostAsync(requestUri, content);                
                string responJsonText = await response.Content.ReadAsStringAsync();                
                if (Utils.StatusCode(response.StatusCode))
                {
                    var dict = JsonConvert.DeserializeObject<Dictionary<string, string>>(responJsonText);
                    ViewController.PopBackToPreviousView();
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
    }
}
