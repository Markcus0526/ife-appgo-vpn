using System;
using System.Collections.Generic;
using System.Drawing;
using System.Windows.Forms;
using AppGo.Controller;
using AppGo.Model;
using AppGo.Util;
using AppGo.View.CustomControls;
using Newtonsoft.Json;
using System.Net.Http;
using System.Net.Http.Headers;

namespace AppGo.View
{
    public partial class MainViewControl : BaseViewControl
    {
        private AGDropDownServiceList DropDownServiceList;

        public MainViewControl(AppGoViewController ViewController)
        {
            this.ViewController = ViewController;

            InitializeComponent();
            //ConnectionStateLabel.Parent = ConnectPictureBox;
            //ConnectionStateLabel.Location = new Point((ConnectPictureBox.Size.Width - ConnectionStateLabel.Size.Width) / 2, 
            //    (ConnectPictureBox.Size.Width - ConnectionStateLabel.Size.Width) / 2);
            
            ServiceListButton.Service = AppPref.Load().GetCurrentService();

            ViewController.Controller.EnableStatusChanged += Controller_EnableStatusChanged;
            ViewController.Controller.ServiceChanged += Controller_ServiceChanged;

            //GetServiceInfo();
            //GetLastNoticficationInfo();

            ViewController.Controller.ToggleEnable(AppPref.Load().enabled);
        }
        

        protected override void UpdateUILanguage()
        {
            base.UpdateUILanguage();

            if (AppPref.Load().enabled) {
                ConnectionStateLabel.Text = LocalizationManager.GetString("connected");
            } else {
                ConnectionStateLabel.Text = LocalizationManager.GetString("connect");
            }
            ServerLabel.Text = LocalizationManager.GetString("server");            
            DataQuotaLabel.Text = LocalizationManager.GetString("network usage");

            NotifyButton.LabelText = LocalizationManager.GetString("notification");
            AccountButton.LabelText = LocalizationManager.GetString("account");
            ShopButton.LabelText = LocalizationManager.GetString("shop");
            SettingsButton.LabelText = LocalizationManager.GetString("settings");            
            DueTimeLabel.Text = LocalizationManager.GetString("usage expire time");

            ServiceListButton.Service = ViewController.Controller.GetConfigurationCopy().GetCurrentService();
            if (DropDownServiceList != null)
                DropDownServiceList.RefreshListItems();
        }

        private void AccountButton_Click(object sender, EventArgs e)
        {
            ViewController.ShowAccountView();
        }

        private void ShopButton_Click(object sender, EventArgs e)
        {
            ViewController.ShowShopView();
        }

        private void SettingsButton_Click(object sender, EventArgs e)
        {
            ViewController.ShowSettingsView();
        }
        
        private void CloseButton_Click(object sender, EventArgs e)
        {
            ViewController.CloseMainForm();
        }

        private void MinimizeButton_Click(object sender, EventArgs e)
        {
            ViewController.MinimizeMainForm();
        }


        private void ConnectPictureBox_Click(object sender, EventArgs e)
        {
            if (ConnectPictureBox.IsOnAnimation)
                return;

            AGService CurrentService = ViewController.Controller.GetConfigurationCopy().GetCurrentService();
            string ruleMode = ViewController.Controller.GetConfigurationCopy().ruleMode;

            if (CurrentService == null)
            {
                Utils.ShowMessageBox(LocalizationManager.GetString("please select vpn server."));
                return;
            }

            if (ViewController.Controller.GetConfigurationCopy().enabled)
                ConnectionStateLabel.Text = LocalizationManager.GetString("disconnecting");
            else
                ConnectionStateLabel.Text = LocalizationManager.GetString("connecting");

            ConnectPictureBox.StartAnimation();

            if (ViewController.Controller.GetConfigurationCopy().enabled)
                DisconnectVPN(CurrentService);
            else
                ConnectVPN(CurrentService);
        }

        private void SelectServiceButton_Click(object sender, EventArgs e)
        {
            ViewController.ShowServiceListView(ServiceListButton.Service, new ServiceSelectionViewControl.ServiceSelected(ServiceList_ServiceSelected));
        }

        private void ServiceListButton_Click(object sender, EventArgs e)
        {
            /*if (DropDownServiceList == null)
            {
                DropDownServiceList = new AGDropDownServiceList(AppPref.Load().services);
                DropDownServiceList.ServiceSelectedDelegate = new AGDropDownServiceList.ServiceSelected(ServiceList_ServiceSelected);
            }

            DropDownServiceList.StartPosition = FormStartPosition.Manual;
            Point location = new Point(ServiceListButton.Location.X, ServiceListButton.Location.Y + ServiceListButton.Size.Height);
            DropDownServiceList.Location = PointToScreen(location);
            int Height = AppPref.Load().services.Count >= 4 ? 120 : AppPref.Load().services.Count * 30;
            DropDownServiceList.Size = new Size(ServiceListButton.Size.Width, Height);
            
            if (ServiceListButton.Service != null)
                DropDownServiceList.SelectedService = ServiceListButton.Service;

            DropDownServiceList.Show();
            DropDownServiceList.Activate();*/
        }

        private void ServiceList_ServiceSelected(AGService Service, int index)
        {
            ServiceListButton.Service = Service;
            ViewController.Controller.SelectServerIndex(index);
            
            RefreshNetworkUsage();            
        }

        
        private void NotifyButton_Click(object sender, EventArgs e)
        {
            ViewController.ShowNotificationView();
        }

        private void NotificationButton_Click(object sender, EventArgs e)
        {
            ViewController.ShowNotificationView();
        }

        private void NotificationLabel_Click(object sender, EventArgs e)
        {
            ViewController.ShowNotificationView();
        }

        private void Controller_EnableStatusChanged(object sender, EventArgs e)
        {
            bool enabled = AppPref.Load().enabled;
            ConnectPictureBox.SetConnected(enabled);            
            if (enabled)
            {
                //ConnectedBackPictureBox.Visible = true;
                ConnectionStateLabel.Text = LocalizationManager.GetString("connected");
                ServiceListButton.Enabled = false;
                SelectServiceButton.Enabled = false;                
            }
            else
            {
                //ConnectedBackPictureBox.Visible = false;
                ConnectionStateLabel.Text = LocalizationManager.GetString("connect");
                ServiceListButton.Enabled = true;
                SelectServiceButton.Enabled = true;                
            }
        }

        private void Controller_ServiceChanged(object sender, EventArgs e)
        {
            AGService Service = ViewController.Controller.GetConfigurationCopy().GetCurrentService();
            ServiceListButton.Service = Service;            
        }
        
        private async void ConnectVPN(AGService CurrentService)
        {
            try
            {
                var client = new HttpClient();
                Uri requestUri = API.Url("user/services");

                client.DefaultRequestHeaders.Add("Accept", API.HEADER_ACCEPT);
                client.DefaultRequestHeaders.Add("Accept-Language", LocalizationManager.CurrentLanguage);
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", ViewController.Controller.GetCurrentConfiguration().accessToken);

                HttpResponseMessage response = await client.GetAsync(requestUri);
                string responJsonText = await response.Content.ReadAsStringAsync();

                ConnectPictureBox.StopAnimation();

                if (Utils.StatusCode(response.StatusCode))
                {
                    List<AGService> serviceList = JsonConvert.DeserializeObject<List<AGService>>(responJsonText);
                    ViewController.Controller.SetServices(serviceList);
                    if (serviceList.Count > 0)
                    {
                        int index = 0;
                        foreach (AGService service in serviceList)
                        {                            
                            if (CurrentService.country.id == service.country.id)
                            {
                                if (service.expire_time.CompareTo(DateTime.Now) < 0 || service.transfer_enable < service.upload + service.download)
                                {
                                    Utils.ShowMessageBox(LocalizationManager.GetString("your vpn server is expired now."));
                                    ConnectionStateLabel.Text = LocalizationManager.GetString("connect");
                                    return;
                                }

                                ViewController.Controller.SelectServerIndex(index);
                                ViewController.Controller.ToggleEnable(true);
                                ConnectionStateLabel.Text = LocalizationManager.GetString("connected");
                                return;
                            }
                            index += 1;
                        }                       
                    }
                    else
                    {
                        Utils.ShowMessageBox(LocalizationManager.GetString("read notificationas and right acceleration"));
                        ConnectionStateLabel.Text = LocalizationManager.GetString("connect");                        
                    }
                }
                else
                {
                    var error = JsonConvert.DeserializeObject<Dictionary<string, string>>(responJsonText);
                    Utils.ShowMessageBox(error["message"]);
                    ConnectionStateLabel.Text = LocalizationManager.GetString("connect");
                }                
            }
            catch (Exception e)
            {
                Utils.ShowMessageBox(LocalizationManager.GetString("can't connect to server."));
                ConnectPictureBox.StopAnimation();
                ConnectionStateLabel.Text = LocalizationManager.GetString("connect");                
            }                        
        }

        private async void DisconnectVPN(AGService CurrentService)
        {
            ViewController.Controller.ToggleEnable(false);

            try
            {
                var client = new HttpClient();
                Uri requestUri = API.Url("user/services");

                client.DefaultRequestHeaders.Add("Accept", API.HEADER_ACCEPT);
                client.DefaultRequestHeaders.Add("Accept-Language", LocalizationManager.CurrentLanguage);
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", ViewController.Controller.GetCurrentConfiguration().accessToken);

                HttpResponseMessage response = await client.GetAsync(requestUri);
                string responJsonText = await response.Content.ReadAsStringAsync();

                ConnectPictureBox.StopAnimation();
                ConnectionStateLabel.Text = LocalizationManager.GetString("connect");

                if (Utils.StatusCode(response.StatusCode))
                {
                    List<AGService> serviceList = JsonConvert.DeserializeObject<List<AGService>>(responJsonText);
                    if (serviceList.Count > 0)
                    {
                        foreach (AGService service in serviceList)
                        {
                            if (CurrentService.country.id == service.country.id)
                            {
                                ServiceListButton.Service = service;
                                RefreshNetworkUsage();                                
                                break;
                            }
                        }
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
                ConnectPictureBox.StopAnimation();
            }            
        }
        
        private void RefreshNetworkUsage()
        {
            AGService Service = ServiceListButton.Service;
            long Usage = Service.upload + Service.download;
            long Total = Service.transfer_enable;
            DataQuotaValueLabel.Text = String.Format("{0} / {1}", Utils.FormatToHumanReadableFileSize(Usage), Utils.FormatToHumanReadableFileSize(Total, false));
            DataQuotaProgressBar.Progress = (int)(Usage * 100 / Total);
            DueTimeValueLabel.Text = Service.expire_time.ToString("yyyy-MM-dd");
        }

        private async void GetServiceInfo()
        {
            AGService CurrentService = ViewController.Controller.GetConfigurationCopy().GetCurrentService();
            if (CurrentService == null)
                return;

            try
            {
                var client = new HttpClient();
                Uri requestUri = API.Url("user/services");

                client.DefaultRequestHeaders.Add("Accept", API.HEADER_ACCEPT);
                client.DefaultRequestHeaders.Add("Accept-Language", LocalizationManager.CurrentLanguage);
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", ViewController.Controller.GetCurrentConfiguration().accessToken);

                HttpResponseMessage response = await client.GetAsync(requestUri);
                string responJsonText = await response.Content.ReadAsStringAsync();
                if (Utils.StatusCode(response.StatusCode))
                {
                    List<AGService> serviceList = JsonConvert.DeserializeObject<List<AGService>>(responJsonText);
                    if (serviceList.Count > 0)
                    {
                        foreach (AGService service in serviceList)
                        {
                            if (CurrentService.country.id == service.country.id)
                            {
                                ServiceListButton.Service = service;
                                RefreshNetworkUsage();
                                break;
                            }
                        }
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

        private async void GetLastNoticficationInfo()
        {
            try
            {
                var client = new HttpClient();
                Uri requestUri = API.Url("notifications");

                client.DefaultRequestHeaders.Add("Accept", API.HEADER_ACCEPT);
                client.DefaultRequestHeaders.Add("Accept-Language", LocalizationManager.CurrentLanguage);
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", ViewController.Controller.GetCurrentConfiguration().accessToken);

                HttpResponseMessage response = await client.GetAsync(requestUri);
                string responJsonText = await response.Content.ReadAsStringAsync();
                if (Utils.StatusCode(response.StatusCode))
                {
                    var notification = JsonConvert.DeserializeObject<AGNotification>(responJsonText);
                    if (notification.data.Count > 0)
                    {
                        NotificationLabel.Text = notification.data[0].title;
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

        
    }
}
