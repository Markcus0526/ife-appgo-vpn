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

    public partial class AGDropDownCountryList : Form
    {
        public delegate void CountrySelected(AGCountry country, int index);
        public CountrySelected CountrySelectedDelegate;
        private AGCountry _SelectedCountry;

        private List<AGCountry> CountryList;

        public int ItemHeight { get; set; } = 30;

        public AGDropDownCountryList(List<AGCountry> Countries)
        {
            CountryList = Countries;

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
            if (CountryList == null)
                return;

            for (int i = 0; i < CountryList.Count; i++)
            {
                AGCountry Country = CountryList[i];
                AGDropDownCountryListItem item = new AGDropDownCountryListItem();
                item.Index = i;
                item.Country = Country;
                item.Click += new EventHandler(ServerListItem_Click);
                if (SelectedCountry != null)
                    item.Selected = (item.Country.id == SelectedCountry.id);
                else
                    item.Selected = false;
                item.IsLastItem = (i == CountryTemplate.CountryInfos.Length - 1);
                CountryListFlowLayoutPanel.Controls.Add(item);
            }
        }

        public void RefreshListItems()
        {
            foreach (AGDropDownCountryListItem item in CountryListFlowLayoutPanel.Controls)
            {
                item.Selected = (item.Country.Equals(SelectedCountry));
                item.Country = item.Country;
            }
        }

        public AGCountry SelectedCountry
        {
            get
            {
                return _SelectedCountry;
            }
            set
            {
                _SelectedCountry = value;
                RefreshListItems();
            }
        }

        private void ServerListItem_Click(object sender, EventArgs e)
        {
            AGDropDownCountryListItem ClickedItem = (AGDropDownCountryListItem)sender;
            SelectedCountry = ClickedItem.Country;

            if (CountrySelectedDelegate != null)
            {
                CountrySelectedDelegate?.Invoke(ClickedItem?.Country, ClickedItem.Index);
            }

            Hide();
        }
        
        private void DropDownServerListControl_SizeChanged(object sender, EventArgs e)
        {
            CountryListFlowLayoutPanel.Size = Size;

            foreach (AGDropDownCountryListItem item in CountryListFlowLayoutPanel.Controls)
            {
                if (CountryListFlowLayoutPanel.Controls.Count > 4)
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
