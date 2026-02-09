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
    public partial class NotificationViewControl : BaseViewControl
    {
        private List<AGNotificationData> NotificationList;

        public NotificationViewControl(AppGoViewController ViewController)
        {
            this.ViewController = ViewController;

            InitializeComponent();

            GetNoticficationInfo();
        }

        protected override void UpdateUILanguage()
        {
            base.UpdateUILanguage();

            TitleBarControl.Title = LocalizationManager.GetString("notifications");
        }

        private void AddListItems()
        {
            for (int i = 0; i < NotificationList.Count; i++)
            {
                AGNotificationData notification = NotificationList[i];
                AGNotificationListItem item = new AGNotificationListItem();
                item.Notification = notification;
                item.Size = new Size(NotificationListFlowLayoutPanel.Size.Width - SystemInformation.VerticalScrollBarWidth, item.Size.Height);
                item.IsLastItem = (i == CountryTemplate.CountryInfos.Length - 1);
                NotificationListFlowLayoutPanel.Controls.Add(item);
            }
        }

        private async void GetNoticficationInfo()
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
                        NotificationList = notification.data;
                        AddListItems();
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
