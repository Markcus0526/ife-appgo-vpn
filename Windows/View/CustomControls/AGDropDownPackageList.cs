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
using AppGo.Util;

namespace AppGo.View.CustomControls
{

    public partial class AGDropDownPackageList : Form
    {
        public delegate void PackageSelected(AGPackage item);
        public PackageSelected PackageSelectedDelegate;
        private AGPackage _SelectedPackage;

        public List<AGPackage> PackageList;

        public int ItemHeight { get; set; } = 20;

        public AGDropDownPackageList()
        {
            InitializeComponent();

            FormBorderStyle = FormBorderStyle.None;
            ShowInTaskbar = false;
        }

        protected override void OnDeactivate(EventArgs e)
        {
            Hide();
        }

        public void SetListItems(List<AGPackage> items)
        {
            if (PackageList == null)
            {
                PackageList = new List<AGPackage>(items);
            }
            else
            {
                PackageList.Clear();
                PackageList.AddRange(items);
            }

            for (int i = 0; i < PackageList.Count; i++)
            {
                AGDropDownPackageListItem item = new AGDropDownPackageListItem();
                item.Index = i;
                item.ItemName = Utils.FormatToHumanReadableFileSize(PackageList[i].transfer, false);
                item.Click += new EventHandler(ShopItemListItem_Click);
                if (SelectedPackage != null)
                    item.Selected = (item.ItemName == Utils.FormatToHumanReadableFileSize(SelectedPackage.transfer, false));
                else
                    item.Selected = false;
                item.IsLastItem = (i == CountryTemplate.CountryInfos.Length - 1);
                ShopItemListFlowLayoutPanel.Controls.Add(item);
            }
        }

        public void RefreshListItems()
        {
            foreach (AGDropDownPackageListItem item in ShopItemListFlowLayoutPanel.Controls)
            {
                item.Selected = (item.ItemName.Equals(SelectedPackage));
            }
        }

        public AGPackage SelectedPackage
        {
            get
            {
                return _SelectedPackage;
            }
            set
            {
                _SelectedPackage = value;
                RefreshListItems();
            }
        }

        private void ShopItemListItem_Click(object sender, EventArgs e)
        {
            AGDropDownPackageListItem ClickedItem = (AGDropDownPackageListItem)sender;
            for (int i = 0; i < PackageList.Count; i++)
            {
                String Item = Utils.FormatToHumanReadableFileSize(PackageList[i].transfer, false);
                if (ClickedItem.ItemName == Item)
                {
                    SelectedPackage = PackageList[i];
                    break;
                }
            }
            
            if (PackageSelectedDelegate != null)
            {
                PackageSelectedDelegate?.Invoke(SelectedPackage);
            }

            Hide();
        }
        
        private void DropDownShopItemListControl_SizeChanged(object sender, EventArgs e)
        {
            int heightSum = 0;

            foreach (AGDropDownPackageListItem item in ShopItemListFlowLayoutPanel.Controls)
            {
                item.Size = new Size(Size.Width, item.Size.Height);
                heightSum += item.Size.Height;
            }

            ShopItemListFlowLayoutPanel.Size = Size;

            if (heightSum != Size.Height)
            {
                Size = new Size(Size.Width, heightSum);
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
