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

namespace AppGo.View.CustomControls
{

    public partial class AGDropDownLanguageList : Form
    {
        public const string LANG_CHINESE = "中文";
        public const string LANG_ENGLISH = "English";

        public delegate void LanguageSelected(string language);
        public LanguageSelected LanguageSelectedDelegate;
        private string _SelectedLanguage;

        public AGDropDownLanguageList()
        {
            InitializeComponent();

            FormBorderStyle = FormBorderStyle.None;
            ShowInTaskbar = false;

            if (LocalizationManager.CurrentLanguage == LocalizationManager.Chinese)
                _SelectedLanguage = LANG_CHINESE;
            else
                _SelectedLanguage = LANG_ENGLISH;

            AddListItems();
        }

        protected override void OnDeactivate(EventArgs e)
        {
            Hide();
        }

        private void AddListItems()
        {
            AGDropDownLanguageListItem ChineseItem = new AGDropDownLanguageListItem();
            ChineseItem.Language = LANG_CHINESE;
            ChineseItem.Click += new EventHandler(LanguageMenuItem_Click);

            if (SelectedLanguage != null)
                ChineseItem.Selected = (ChineseItem.Language == SelectedLanguage);
            else
                ChineseItem.Selected = false;

            ChineseItem.IsLastItem = false;
            LanguageMenuFlowLayoutPanel.Controls.Add(ChineseItem);

            AGDropDownLanguageListItem EnglishItem = new AGDropDownLanguageListItem();
            EnglishItem.Language = LANG_ENGLISH;
            EnglishItem.Click += new EventHandler(LanguageMenuItem_Click);

            if (SelectedLanguage != null)
                EnglishItem.Selected = (EnglishItem.Language == SelectedLanguage);
            else
                EnglishItem.Selected = false;

            EnglishItem.IsLastItem = false;
            LanguageMenuFlowLayoutPanel.Controls.Add(EnglishItem);
        }

        private void RefreshListItems()
        {
            foreach (AGDropDownLanguageListItem item in LanguageMenuFlowLayoutPanel.Controls)
            {
                item.Selected = (item.Language == SelectedLanguage);
            }
        }

        public string SelectedLanguage
        {
            get
            {
                return _SelectedLanguage;
            }
            set
            {
                _SelectedLanguage = value;
                RefreshListItems();
            }
        }

        private void LanguageMenuItem_Click(object sender, EventArgs e)
        {
            AGDropDownLanguageListItem ClickedItem = (AGDropDownLanguageListItem)sender;
            SelectedLanguage = ClickedItem.Language;

            if (LanguageSelectedDelegate != null)
            {
                LanguageSelectedDelegate?.Invoke(ClickedItem?.Language);
            }

            Hide();
        }

        private void DropDownLanguageMenuControl_SizeChanged(object sender, EventArgs e)
        {
            LanguageMenuFlowLayoutPanel.Size = Size;

            foreach (AGDropDownLanguageListItem item in LanguageMenuFlowLayoutPanel.Controls)
            {
                item.Size = new Size(Size.Width, item.Size.Height);
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
    }
}
