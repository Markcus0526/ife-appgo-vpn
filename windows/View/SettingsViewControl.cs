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
using AppGo.View.CustomControls;

namespace AppGo.View
{
    public partial class SettingsViewControl : BaseViewControl
    {
        private AGDropDownLanguageList DropDownLanguageMenu;

        public SettingsViewControl(AppGoViewController ViewController)
        {
            this.ViewController = ViewController;

            InitializeComponent();

            LanguageSettingControl.Click += new EventHandler(LanguageSettingControl_Click);
            ViewController.Controller.LaunchAtLoginChanged += Controller_LaunchAtLoginChanged;
            ViewController.Controller.ShareOverLANStatusChanged += Controller_ShareOverLANStatusChanged;

            LaunchAtLogInSettingControl.Checked = AutoStartup.Check();

            if (LocalizationManager.CurrentLanguage == LocalizationManager.Chinese)
                LanguageSettingControl.Language = AGDropDownLanguageList.LANG_CHINESE;
            else
                LanguageSettingControl.Language = AGDropDownLanguageList.LANG_ENGLISH;
        }
        

        protected override void UpdateUILanguage()
        {
            base.UpdateUILanguage();

            TitleBarControl.Title = LocalizationManager.GetString("settings");
            LanguageSettingControl.Text = LocalizationManager.GetString("language");
            LaunchAtLogInSettingControl.Label = LocalizationManager.GetString("launch at login");
            ShareOverLANSettingControl.Label = LocalizationManager.GetString("allow other devices to connect");
        }

        private void LanguageSettingControl_Click(object sender, EventArgs e)
        {
            LanguageSettingControl.IsOpeningMenu = !LanguageSettingControl.IsOpeningMenu;

            if (DropDownLanguageMenu == null)
            {
                DropDownLanguageMenu = new AGDropDownLanguageList();
                DropDownLanguageMenu.LanguageSelectedDelegate = new AGDropDownLanguageList.LanguageSelected(DropDownLanguageMenuControl_LanguageSelected);
                DropDownLanguageMenu.VisibleChanged += new EventHandler(DropDownLanguageMenuControl_VisbleChanged);
            }

            if (LanguageSettingControl.Language != null)
                DropDownLanguageMenu.SelectedLanguage = LanguageSettingControl.Language;

            DropDownLanguageMenu.Show();
            DropDownLanguageMenu.Activate();

            DropDownLanguageMenu.StartPosition = FormStartPosition.Manual;
            Point location = new Point(LanguageSettingControl.Location.X, LanguageSettingControl.Location.Y + LanguageSettingControl.Size.Height);
            DropDownLanguageMenu.Location = PointToScreen(location);
            DropDownLanguageMenu.Size = new Size(LanguageSettingControl.Size.Width, 60);
        }

        private void DropDownLanguageMenuControl_VisbleChanged(object sender, EventArgs e)
        {
            if (!DropDownLanguageMenu.Visible)
                LanguageSettingControl.IsOpeningMenu = false;
        }

        private void DropDownLanguageMenuControl_LanguageSelected(string language)
        {
            if (language == AGDropDownLanguageList.LANG_CHINESE)
            {
                ViewController.Controller.SetUserLanguage(LocalizationManager.Chinese);
                LanguageSettingControl.Language = AGDropDownLanguageList.LANG_CHINESE;
            }
            else
            {
                ViewController.Controller.SetUserLanguage(LocalizationManager.English);
                LanguageSettingControl.Language = AGDropDownLanguageList.LANG_ENGLISH;
            }            
        }

        private void LaunchAtLogInSettingControl_Click(object sender, EventArgs e)
        {
            ViewController.Controller.ToggleLaunchAtLogin(!LaunchAtLogInSettingControl.Checked);
        }

        private void Controller_LaunchAtLoginChanged(object sender, EventArgs e)
        {
            LaunchAtLogInSettingControl.Checked = AutoStartup.Check();
        }

        private void ShareOverLANSettingControl_Click(object sender, EventArgs e)
        {
            ViewController.Controller.ToggleShareOverLAN(!ShareOverLANSettingControl.Checked);
        }

        private void Controller_ShareOverLANStatusChanged(object sender, EventArgs e)
        {
            ShareOverLANSettingControl.Checked = ViewController.Controller.GetConfigurationCopy().shareOverLan;
        }
    }
}
