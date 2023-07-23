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
using System.Collections.Specialized;
using System.Net;
using Newtonsoft.Json;
using AppGo.Util;
using System.IO;
using System.Net.Http;
using System.Net.Http.Headers;

namespace AppGo.View
{
    public partial class ServiceSelectionViewControl : BaseViewControl
    {
        public delegate void ServiceSelected(AGService server, int index);
        public ServiceSelected ServiceSelectedDelegate;
        private AGService _SelectedService;

        private List<AGService> ServiceList;

        public ServiceSelectionViewControl(AppGoViewController ViewController, AGService SelectedService, ServiceSelected ServiceSelectedDelegate)
        {
            this.ViewController = ViewController;

            InitializeComponent();

            NoServerLabel.Visible = false;

            ServiceList = AppPref.Load().services;
            AddListItems();

            this.SelectedService = SelectedService;
            this.ServiceSelectedDelegate = ServiceSelectedDelegate;
        }
        
        protected override void UpdateUILanguage()
        {
            base.UpdateUILanguage();

            NoServerLabel.Text = LocalizationManager.GetString("purchase data plan first");
            TitleBarControl.Title = LocalizationManager.GetString("choose server");
            OKButton.Text = LocalizationManager.GetString("ok");
        }

        private async void AddListItems()
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
                if (Utils.StatusCode(response.StatusCode))
                {
                    ServiceList = JsonConvert.DeserializeObject<List<AGService>>(responJsonText);
                    if (ServiceList.Count == 0)
                    {
                        ServerListFlowLayoutPanel.Visible = false;
                        NoServerLabel.Visible = true;
                    }
                    else
                    {
                        ServerListFlowLayoutPanel.Visible = true;

                        for (int i = 0; i < ServiceList.Count; i++)
                        {
                            AGServiceListItem item = new AGServiceListItem();
                            item.Index = i;
                            item.Server = ServiceList[i];
                            item.Size = new Size(ServerListFlowLayoutPanel.Size.Width - SystemInformation.VerticalScrollBarWidth, item.Size.Height);
                            item.Click += new EventHandler(ServerListItem_Click);
                            if (SelectedService != null)
                                item.Selected = (item.Server.server_ip == SelectedService.server_ip);
                            else
                                item.Selected = false;
                            //item.IsLastItem = (i == Country.CountryInfos.Length - 1);
                            ServerListFlowLayoutPanel.Controls.Add(item);
                        }
                    }                    

                    ViewController.Controller.SetServices(ServiceList);

                    UpdateAvailability();
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

        private void RefreshListItems()
        {
            foreach (AGServiceListItem item in ServerListFlowLayoutPanel.Controls)
            {
                item.Selected = (item.Server.server_ip == SelectedService.server_ip);
                item.Server = item.Server;
            }
        }

        private void UpdateAvailability()
        {
            foreach (AGServiceListItem item in ServerListFlowLayoutPanel.Controls)
            {
                AGPing myPing = new AGPing(item.Server, 3);
                myPing.Completed += new EventHandler<AGPing.CompletedEventArgs>(Ping_Completed);
                myPing.Start(item);
            }
        }

        private void Ping_Completed(object sender, AGPing.CompletedEventArgs e)
        {
            AGService server = e.Server;
            AGServiceListItem item = (AGServiceListItem) e.UserState;

            if (e.RoundtripTime == null)
                return;
            var records = e.RoundtripTime.Where(response => response != null).Select(response => response.Value).ToList();
            if (!records.Any())
                return;
            int? AverageResponse = (int?)records.Average();
            server.delay = AverageResponse.Value;

            Invoke((MethodInvoker)delegate
            {
                item.Server = server;
            });
        }
        
        public AGService SelectedService
        {
            get
            {
                return _SelectedService;
            }
            set
            {
                _SelectedService = value;
                RefreshListItems();
            }
        }

        private void ServerListItem_Click(object sender, EventArgs e)
        {
            AGServiceListItem ClickedItem = (AGServiceListItem)sender;
            SelectedService = ClickedItem.Server;
            ServiceSelectedDelegate?.Invoke(SelectedService, ClickedItem.Index);
        }

        private void OKButton_Click(object sender, EventArgs e)
        {
            if (ServiceSelectedDelegate != null)
            {
                AGServiceListItem ClickedItem = null;

                foreach (AGServiceListItem item in ServerListFlowLayoutPanel.Controls)
                {
                    if (item.Selected)
                    {
                        ClickedItem = item;
                        break;
                    }
                }
                if (ClickedItem != null)
                    ServiceSelectedDelegate?.Invoke(ClickedItem?.Server, ClickedItem.Index);
            }

            ViewController.PopBackToPreviousView();
        }

        private void RemoveButton_Click(object sender, EventArgs e)
        {
            AGServiceListItem SelectedItem = null;

            foreach (AGServiceListItem item in ServerListFlowLayoutPanel.Controls)
            {
                if (item.Selected)
                {
                    SelectedItem = item;
                    break;
                }
            }

            //TODO: Implement this
        }
    }
}
