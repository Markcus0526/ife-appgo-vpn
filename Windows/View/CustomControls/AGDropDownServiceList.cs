using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using AppGo.Model;

namespace AppGo.View.CustomControls
{

    public partial class AGDropDownServiceList : Form
    {
        public delegate void ServiceSelected(AGService server, int index);
        public ServiceSelected ServiceSelectedDelegate;
        private AGService _SelectedService;

        private List<AGService> ServiceList;

        public int ItemHeight { get; set; } = 30;

        public AGDropDownServiceList(List<AGService> Services)
        {
            ServiceList = Services;

            InitializeComponent();

            FormBorderStyle = FormBorderStyle.None;
            ShowInTaskbar = false;

            AddListItems();
        }

        protected override void OnDeactivate(EventArgs e)
        {
            Hide();
        }

        private void AddListItems()
        {
            for (int i = 0; i < ServiceList.Count; i++)
            {
                AGService Service = ServiceList[i];
                AGDropDownServiceListItem item = new AGDropDownServiceListItem();
                item.Index = i;
                item.Service = Service;
                item.Click += new EventHandler(ServerListItem_Click);
                if (SelectedService != null)
                    item.Selected = (item.Service.server_ip == SelectedService.server_ip);
                else
                    item.Selected = false;
                item.IsLastItem = (i == CountryTemplate.CountryInfos.Length - 1);
                ServiceListFlowLayoutPanel.Controls.Add(item);
            }
        }

        public void RefreshListItems()
        {
            foreach (AGDropDownServiceListItem item in ServiceListFlowLayoutPanel.Controls)
            {
                item.Selected = (item.Service.Equals(SelectedService));
                item.Service = item.Service;
            }
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
            AGDropDownServiceListItem ClickedItem = (AGDropDownServiceListItem)sender;
            SelectedService = ClickedItem.Service;

            if (ServiceSelectedDelegate != null)
            {
                ServiceSelectedDelegate?.Invoke(ClickedItem?.Service, ClickedItem.Index);
            }

            Hide();
        }
        
        private void DropDownServerListControl_SizeChanged(object sender, EventArgs e)
        {
            ServiceListFlowLayoutPanel.Size = Size;

            foreach (AGDropDownServiceListItem item in ServiceListFlowLayoutPanel.Controls)
            {
                if (ServiceListFlowLayoutPanel.Controls.Count > 4)
                    item.Size = new Size(Size.Width - SystemInformation.VerticalScrollBarWidth, ItemHeight);
                else
                    item.Size = new Size(Size.Width, ItemHeight);
            }
        }

        protected override CreateParams CreateParams
        {
            get
            {
                const int CS_DROPSHADOW = 0x00020000;
                CreateParams cp = base.CreateParams;
                cp.ClassStyle |= CS_DROPSHADOW;
                return cp;
            }
        }

        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        private static extern IntPtr SendMessage(IntPtr hWnd, UInt32 Msg, IntPtr wParam, IntPtr lParam);
    }
}
