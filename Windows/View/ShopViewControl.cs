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
using AppGo.View.CustomControls;
using System.IO;
using System.Collections.Specialized;
using System.Net;
using AppGo.Util;
using Newtonsoft.Json;
using System.Globalization;
using System.Net.Http;
using System.Net.Http.Headers;

namespace AppGo.View
{
    public partial class ShopViewControl : BaseViewControl
    {
        private AGDropDownPackageList DropDownDataQuotaList;

        private AGDropDownCountryList DropDownCountryList;
        private Pen SplitterPen = new Pen(Color.FromArgb(88, 199, 255));

        private List<AGCountry> CountryList;
        private List<AGPackage> PackageList;        
        private AGPackage SelectedPackage;
        private Dictionary<string, bool> SwitchList = new Dictionary<string, bool>();
        private int PaymentCount = 0;
        private string SelectedPayment = "";

        public ShopViewControl(AppGoViewController ViewController)
        {
            this.ViewController = ViewController;

            InitializeComponent();

            GetCountryInfo();
            GetPaymentSwitchInfo();
        }
        
        protected override void UpdateUILanguage()
        {
            base.UpdateUILanguage();

            TitleBarControl.Title = LocalizationManager.GetString("shop");

            FeatureLabel.Text = LocalizationManager.GetString("package description");

            ServerLabel.Text = LocalizationManager.GetString("server");
            DataQuotaLabel.Text = LocalizationManager.GetString("transfer");
            PeriodLabel.Text = LocalizationManager.GetString("duration");

            PriceLabel.Text = LocalizationManager.GetString("price");
            SelectPaymentMethodLabel.Text = LocalizationManager.GetString("select payment method");

            AttentionLabel.Text = LocalizationManager.GetString("attention:");
            AttentionContentLabel.Text = LocalizationManager.GetString("cluster attention content");

            BuyNowButton.Text = LocalizationManager.GetString("buy now");
        }

        private void UpdateCountryInfo(AGCountry Country)
        {
            CountryListButton.Country = Country;
            FeatureValueLabel.Text = Utils.GetLocalizedDescription(Country.description);
            GetPackageInfo(Country.id);
        }
        
        private void UpdatePackageInfo(AGPackage Package)
        {
            CountryListButton.Enabled = true;
            DataQuoteButton.Enabled = true;

            DataQuoteButton.Title = Utils.FormatToHumanReadableFileSize(Package.transfer, false);
            PeriodValueLabel.Text = String.Format("{0} {1}", Package.duration, LocalizationManager.GetString("days"));
            if (LocalizationManager.CurrentLanguage == LocalizationManager.Chinese)
                PriceValueLabel.Text = String.Format("{0} {1}", Package.price, LocalizationManager.GetString("¥"));
            else
                PriceValueLabel.Text = String.Format("{0} {1}", LocalizationManager.GetString("¥"), Package.price);
        }


        private void Pay1Button_Click(object sender, EventArgs e)
        {
            Pay1Button.Selected = true;
            Pay2Button.Selected = false;
            Pay3Button.Selected = false;
            SelectedPayment = Pay1Button.HiddenText;
        }

        private void Pay2Button_Click(object sender, EventArgs e)
        {
            Pay1Button.Selected = false;
            Pay2Button.Selected = true;
            Pay3Button.Selected = false;
            SelectedPayment = Pay2Button.HiddenText;
        }

        private void Pay3Button_Click(object sender, EventArgs e)
        {
            Pay1Button.Selected = false;
            Pay2Button.Selected = false;
            Pay3Button.Selected = true;
            SelectedPayment = Pay3Button.HiddenText;
        }
        
        private void PaymentPanel_Paint(object sender, PaintEventArgs e)
        {
            //e.Graphics.DrawLine(SplitterPen, 18, 153, 282, 153);
        }

        private void CountryListButton_Click(object sender, EventArgs e)
        {
            if (DropDownCountryList == null)
            {
                DropDownCountryList = new AGDropDownCountryList(CountryList);
                DropDownCountryList.CountrySelectedDelegate = new AGDropDownCountryList.CountrySelected(DropDownCountryList_CountrySelected);
                DropDownCountryList.ItemHeight = CountryListButton.Size.Height;
            }

            if (CountryListButton.Country != null)
                DropDownCountryList.SelectedCountry = CountryListButton.Country;

            DropDownCountryList.Show();
            DropDownCountryList.Activate();

            DropDownCountryList.StartPosition = FormStartPosition.Manual;
            Point location = new Point(PaymentPanel.Location.X + CountryListButton.Location.X,
                PaymentPanel.Location.Y + CountryListButton.Location.Y + CountryListButton.Size.Height);
            DropDownCountryList.Location = PointToScreen(location);
            DropDownCountryList.Size = new Size(CountryListButton.Size.Width, 126);
        }

        private void DropDownCountryList_CountrySelected(AGCountry Country, int index)
        {
            if (CountryListButton.Country.id != Country.id)
            {
                CountryListButton.Country = Country;
                UpdateCountryInfo(Country);                
            }
        }

        private void DataQuoteButton_Click(object sender, EventArgs e)
        {
            DropDownDataQuotaList = new AGDropDownPackageList();
            DropDownDataQuotaList.PackageSelectedDelegate = new AGDropDownPackageList.PackageSelected(DropDownDataQuotaList_ItemSelected);
            DropDownDataQuotaList.ItemHeight = DataQuoteButton.Size.Height;

            DropDownDataQuotaList.SetListItems(PackageList);

            if (!DataQuoteButton.Title.IsNullOrEmpty())
                DropDownDataQuotaList.SelectedPackage = SelectedPackage;
            
            DropDownDataQuotaList.Show();
            DropDownDataQuotaList.Activate();

            DropDownDataQuotaList.StartPosition = FormStartPosition.Manual;
            Point location = new Point(DataQuoteButton.Location.X + PaymentPanel.Location.X, 
                DataQuoteButton.Location.Y + PaymentPanel.Location.Y + DataQuoteButton.Size.Height);
            DropDownDataQuotaList.Location = PointToScreen(location);
            DropDownDataQuotaList.Size = new Size(DataQuoteButton.Size.Width, 90);
        }

        private void DropDownDataQuotaList_ItemSelected(AGPackage Item)
        {
            SelectedPackage = Item;
            UpdatePackageInfo(SelectedPackage);            
        }


        private void BuyNowButton_Click(object sender, EventArgs e)
        {
            GetCartInfo();
        }

        private void UpdateSwitch()
        {
            if (PaymentCount == 0)
            {
                Pay1Button.Visible = false;
                Pay2Button.Visible = false;
                Pay3Button.Visible = false;
                BuyNowButton.Visible = false;
            }
            else if (PaymentCount == 1)
            {
                Pay1Button.Visible = false;
                Pay2Button.Visible = true;
                Pay3Button.Visible = false;
                BuyNowButton.Visible = true;

                if (SwitchList["alipay"])
                {
                    Pay2Button.NormalImage = AppGo.Properties.Resources.ic_alipay_normal;
                    Pay2Button.SelectedImage = AppGo.Properties.Resources.ic_alipay_selected;
                    Pay2Button.HiddenText = "alipayWeb";
                }
                else if (SwitchList["global_alipay"])
                {
                    Pay2Button.NormalImage = AppGo.Properties.Resources.ic_alipay_normal;
                    Pay2Button.SelectedImage = AppGo.Properties.Resources.ic_alipay_selected;
                    Pay2Button.HiddenText = "globalAlipayWeb";
                }
                else if (SwitchList["acoin"])
                {
                    Pay2Button.NormalImage = AppGo.Properties.Resources.ic_acoin_normal;
                    Pay2Button.SelectedImage = AppGo.Properties.Resources.ic_acoin_selected;
                    Pay2Button.HiddenText = "acoin";
                }

                Pay2Button.Selected = true;
                SelectedPayment = Pay2Button.HiddenText;
            }
            else if (PaymentCount == 2)
            {
                Pay1Button.Visible = true;
                Pay2Button.Visible = false;
                Pay3Button.Visible = true;
                BuyNowButton.Visible = true;                

                if (SwitchList["alipay"] && SwitchList["global_alipay"])
                {
                    Pay1Button.NormalImage = AppGo.Properties.Resources.ic_alipay_normal;
                    Pay1Button.SelectedImage = AppGo.Properties.Resources.ic_alipay_selected;
                    Pay1Button.HiddenText = "alipayWeb";

                    Pay3Button.BackgroundImage = AppGo.Properties.Resources.ic_alipay_normal;
                    Pay3Button.NormalImage = AppGo.Properties.Resources.ic_alipay_normal;
                    Pay3Button.SelectedImage = AppGo.Properties.Resources.ic_alipay_selected;
                    Pay3Button.HiddenText = "globalAlipayWeb";
                }
                else
                {                   
                    if (SwitchList["alipay"])
                    {
                        Pay1Button.NormalImage = AppGo.Properties.Resources.ic_alipay_normal;
                        Pay1Button.SelectedImage = AppGo.Properties.Resources.ic_alipay_selected;
                        Pay1Button.HiddenText = "alipayWeb";
                    }
                    else if (SwitchList["global_alipay"])
                    {
                        Pay1Button.NormalImage = AppGo.Properties.Resources.ic_alipay_normal;
                        Pay1Button.SelectedImage = AppGo.Properties.Resources.ic_alipay_selected;
                        Pay1Button.HiddenText = "globalAlipayWeb";
                    }

                    if (SwitchList["acoin"])
                    {
                        Pay3Button.BackgroundImage = AppGo.Properties.Resources.ic_acoin_normal;
                        Pay3Button.NormalImage = AppGo.Properties.Resources.ic_acoin_normal;
                        Pay3Button.SelectedImage = AppGo.Properties.Resources.ic_acoin_selected;
                        Pay3Button.HiddenText = "acoin";
                    }
                }

                Pay1Button.Selected = true;
                SelectedPayment = Pay1Button.HiddenText;
            }
            else if (SwitchList.Count >= 3)
            {
                Pay1Button.Visible = true;
                Pay2Button.Visible = true;
                Pay3Button.Visible = true;
                BuyNowButton.Visible = true;                

                Pay1Button.NormalImage = AppGo.Properties.Resources.ic_alipay_normal;
                Pay1Button.SelectedImage = AppGo.Properties.Resources.ic_alipay_selected;
                Pay1Button.HiddenText = "alipayWeb";

                Pay2Button.BackgroundImage = AppGo.Properties.Resources.ic_alipay_normal;
                Pay2Button.NormalImage = AppGo.Properties.Resources.ic_alipay_normal;
                Pay2Button.SelectedImage = AppGo.Properties.Resources.ic_alipay_selected;
                Pay2Button.HiddenText = "globalAlipayWeb";

                Pay3Button.BackgroundImage = AppGo.Properties.Resources.ic_acoin_normal;
                Pay3Button.NormalImage = AppGo.Properties.Resources.ic_acoin_normal;
                Pay3Button.SelectedImage = AppGo.Properties.Resources.ic_acoin_selected;
                Pay3Button.HiddenText = "acoin";

                Pay1Button.Selected = true;
                SelectedPayment = Pay1Button.HiddenText;
            }
        }

        private async void GetCountryInfo()
        {
            try
            {
                var client = new HttpClient();
                Uri requestUri = API.Url("countries");

                client.DefaultRequestHeaders.Add("Accept", API.HEADER_ACCEPT);
                client.DefaultRequestHeaders.Add("Accept-Language", LocalizationManager.CurrentLanguage);
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", ViewController.Controller.GetCurrentConfiguration().accessToken);

                HttpResponseMessage response = await client.GetAsync(requestUri);
                string responJsonText = await response.Content.ReadAsStringAsync();
                if (Utils.StatusCode(response.StatusCode))
                {
                    CountryList = JsonConvert.DeserializeObject<List<AGCountry>>(responJsonText);
                    if (CountryList.Count > 0)
                    {
                        UpdateCountryInfo(CountryList[0]);
                    }
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

        private async void GetPackageInfo(int CountryId)
        {
            try
            {
                var client = new HttpClient();
                Uri requestUri = API.Url("country/" + CountryId.ToString() + "/packages");

                client.DefaultRequestHeaders.Add("Accept", API.HEADER_ACCEPT);
                client.DefaultRequestHeaders.Add("Accept-Language", LocalizationManager.CurrentLanguage);
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", ViewController.Controller.GetCurrentConfiguration().accessToken);

                HttpResponseMessage response = await client.GetAsync(requestUri);
                string responJsonText = await response.Content.ReadAsStringAsync();
                if (Utils.StatusCode(response.StatusCode))
                {
                    PackageList = JsonConvert.DeserializeObject<List<AGPackage>>(responJsonText);
                    if (PackageList.Count > 0)
                    {
                        SelectedPackage = PackageList[0];
                        UpdatePackageInfo(SelectedPackage);
                    }
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

        private async void GetCartInfo()
        {
            try
            {
                var client = new HttpClient();
                Uri requestUri = API.Url("cart");
                //Uri requestUri = new Uri("https://dev.yeseji.com/cart");

                client.DefaultRequestHeaders.Add("Accept", API.HEADER_ACCEPT);
                client.DefaultRequestHeaders.Add("Accept-Language", LocalizationManager.CurrentLanguage);
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", ViewController.Controller.GetCurrentConfiguration().accessToken);

                var parameters = new Dictionary<string, string>();
                parameters["payment_method"] = SelectedPayment; //alipay,acoin,itunes,play,alipayWeb,globalAlipayApp,globalAlipayWeb
                parameters["package_id"] = SelectedPackage.id.ToString();
                HttpContent content = new FormUrlEncodedContent(parameters);
                content.Headers.Add("Content-Language", LocalizationManager.CurrentLanguage);

                HttpResponseMessage response = await client.PostAsync(requestUri, content);
                string responJsonText = await response.Content.ReadAsStringAsync();
                if (Utils.StatusCode(response.StatusCode))
                {
                    var PayInfo = JsonConvert.DeserializeObject<Dictionary<String, Object>>(responJsonText);
                    if (SelectedPayment == "alipayWeb" || SelectedPayment == "globalAlipayWeb")
                        PayWithAlipay(PayInfo);
                    else
                        PayWithAcoin(PayInfo);
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

        private void PayWithAlipay(Dictionary<String, Object> JsonInfo)
        {
            string TargetURL = (string)JsonInfo["url"];
            System.Diagnostics.Process.Start(TargetURL);
        }

        private void PayWithAcoin(Dictionary<String, Object> JsonInfo)
        {
            string TradeNo = (string)JsonInfo["trade_no"];
            long Fee = (long)JsonInfo["fee"];
            SetAcoinInfo(TradeNo, Fee);
        }

        private async void SetAcoinInfo(String tradeNo, long fee)
        {
            try
            {
                var client = new HttpClient();
                Uri requestUri = API.Url("pay/validate/acoin");

                client.DefaultRequestHeaders.Add("Accept", API.HEADER_ACCEPT);
                client.DefaultRequestHeaders.Add("Accept-Language", LocalizationManager.CurrentLanguage);
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", ViewController.Controller.GetCurrentConfiguration().accessToken);

                var parameters = new Dictionary<string, string>();
                string payment = Pay1Button.Selected ? "globalAlipayWeb" : "acoin";
                parameters["trade_no"] = tradeNo;
                parameters["fee"] = fee.ToString();
                HttpContent content = new FormUrlEncodedContent(parameters);
                content.Headers.Add("Content-Language", LocalizationManager.CurrentLanguage);

                HttpResponseMessage response = await client.PostAsync(requestUri, content);
                string responJsonText = await response.Content.ReadAsStringAsync();
                if (Utils.StatusCode(response.StatusCode))
                {
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
        }

        private async void GetPaymentSwitchInfo()
        {
            try
            {
                var client = new HttpClient();
                Uri requestUri = API.Url("switch/payment");
                //Uri requestUri = new Uri("https://dev.yeseji.com/switch/payment");

                client.DefaultRequestHeaders.Add("Accept", API.HEADER_ACCEPT);
                client.DefaultRequestHeaders.Add("Accept-Language", LocalizationManager.CurrentLanguage);
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", ViewController.Controller.GetCurrentConfiguration().accessToken);

                HttpResponseMessage response = await client.GetAsync(requestUri);
                string responJsonText = await response.Content.ReadAsStringAsync();
                if (Utils.StatusCode(response.StatusCode))
                {
                    var dict = JsonConvert.DeserializeObject<Dictionary<string, string>>(responJsonText);
                    
                    if (dict["alipay"] == "on")
                    {
                        SwitchList.Add("alipay", true);
                        PaymentCount++;
                    }
                    else
                        SwitchList.Add("alipay", false);

                    if (dict["global_alipay"] == "on")
                    {
                        SwitchList.Add("global_alipay", true);
                        PaymentCount++;
                    }
                    else
                        SwitchList.Add("global_alipay", false);

                    if (dict["acoin"] == "on")
                    {
                        SwitchList.Add("acoin", true);
                        PaymentCount++;
                    }
                    else
                        SwitchList.Add("acoin", false);

                    /*PaymentCount = 0;
                    SwitchList.Clear();
                    SwitchList.Add("alipay", true);
                    PaymentCount++;
                    SwitchList.Add("global_alipay", true);
                    PaymentCount++;
                    SwitchList.Add("acoin", true);
                    PaymentCount++;*/

                    UpdateSwitch();
                    BuyNowButton.Visible = true;
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
