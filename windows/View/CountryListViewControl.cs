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

namespace AppGo.View
{
    public partial class CountryListViewControl : BaseViewControl
    {
        public CountrySelected CountrySelectedDelegate;
        private CountryInfo _SelectedCountry;

        public CountryListViewControl(AppGoViewController ViewController)
        {
            this.ViewController = ViewController;

            InitializeComponent();
        }

        private void CountryListViewControl_Load(object sender, EventArgs e)
        {
            AddListItems();
        }

        protected override void UpdateUILanguage()
        {
            base.UpdateUILanguage();

            TitleBarControl.Title = LocalizationManager.GetString("country code");
            OKButton.Text = LocalizationManager.GetString("ok");

            RefreshListItems();
        }

        private void AddListItems()
        {
            for (int i = 0; i < CountryTemplate.CountryInfos.Length; i++)
            {
                if (CountryTemplate.CountryInfos[i].Code == "Trial") continue;

                CountryInfo country = CountryTemplate.CountryInfos[i];
                AGCountryCodeListItem item = new AGCountryCodeListItem();
                item.Index = i;
                item.CountryInfo = country;
                item.Size = new Size(CountryCodeFlowLayoutPanel.Size.Width - SystemInformation.VerticalScrollBarWidth, item.Size.Height);
                item.Click += new EventHandler(CountryCodeListItem_Click);
                item.Selected = (item.CountryInfo == SelectedCountry);
                item.IsLastItem = (i == CountryTemplate.CountryInfos.Length - 1);
                CountryCodeFlowLayoutPanel.Controls.Add(item);
            }
        }

        private void RefreshListItems()
        {
            foreach (AGCountryCodeListItem item in CountryCodeFlowLayoutPanel.Controls)
            {
                item.Selected = (item.CountryInfo == SelectedCountry);
                //item.CountryInfo = item.CountryInfo;
            }
        }

        public CountryInfo SelectedCountry
        {
            get
            {
                return _SelectedCountry;
            }
            set
            {
                if (value == null)
                    _SelectedCountry = CountryTemplate.CountryInfos[0];
                else
                    _SelectedCountry = value;
                RefreshListItems();
            }
        }

        private void CountryCodeListItem_Click(object sender, EventArgs e)
        {
            AGCountryCodeListItem ClickedItem = (AGCountryCodeListItem) sender;
            SelectedCountry= ClickedItem.CountryInfo;
            //RefreshListItems();
            CountrySelectedDelegate?.Invoke(SelectedCountry);
        }

        private void OKButton_Click(object sender, EventArgs e)
        {
            if (CountrySelectedDelegate != null)
            {
                AGCountryCodeListItem ClickedItem = null;

                foreach (AGCountryCodeListItem item in CountryCodeFlowLayoutPanel.Controls)
                {
                    if (item.Selected)
                    {
                        ClickedItem = item;
                        break;
                    }
                }
                CountrySelectedDelegate?.Invoke(ClickedItem?.CountryInfo);
            }

            ViewController.PopBackToPreviousView();
        }

        public delegate void CountrySelected(CountryInfo country);
        
    }
}
