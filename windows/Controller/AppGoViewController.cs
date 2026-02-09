using System;
using System.Collections.Generic;
using System.Drawing;
using System.Windows.Forms;
using AppGo.Model;
using AppGo.Util;
using AppGo.View;
using System.IO;
using System.Net;
using System.Collections.Specialized;
using Newtonsoft.Json;
using AppGo.Properties;

namespace AppGo.Controller
{
    public class AppGoViewController
    {
        public AppGoController Controller;

        private NotifyIcon _NotifyIcon;

        private Bitmap icon_current, icon_connected, icon_disconnected;

        private ContextMenu MainMenu;

        private bool _isFirstRun;
        
        #region Menu Items

        private MenuItem ConnectionStatusItem;
        private MenuItem ToggleConnectionStatusItem;
        private MenuItem ServersItem;
        private MenuItem LaunchAtLoginItem;
        private MenuItem QuitItem;

        #endregion

        #region View Controls

        public MainForm MainForm;
        private MainViewControl MainView;
        private SplashViewControl SplashView;
        private LoginViewControl LoginView;
        private SignUpViewControl SignUpView;
        private AboutUsViewControl AboutUsView;
        private ServiceSelectionViewControl ServiceListView;
        private SettingsViewControl SettingsView;
        private TermsOfUseViewControl TermsOfUseView;
        private ShopViewControl ShopView;
        private FeedbackViewControl FeedbackView;
        private AccountViewControl AccountView;
        private ForgotPasswordViewControl ForgotPasswordView;
        private CountryListViewControl CountryListView;
        private NotificationViewControl NotificationView;

        #endregion

        public AppGoViewController(AppGoController Controller)
        {
            this.Controller = Controller;

            Controller.EnableStatusChanged += Controller_EnableStatusChanged;
            Controller.ConfigChanged += Controller_ConfigChanged;
            Controller.ServiceChanged += Controller_ServiceChanged;
            Controller.LaunchAtLoginChanged += Controller_LaunchAtLoginChanged;
            Controller.UserLanguageChanged += Controller_LanguageChanged;
            Controller.LoginChanged += Controller_LoginChanged;
            
            _NotifyIcon = new NotifyIcon();
            UpdateTrayIcon();
            _NotifyIcon.Visible = true;
            _NotifyIcon.MouseDoubleClick += NotifyIcon_DoubleClick;
            
            LoadMenu();

            LoadCurrentConfiguration();

            ShowMainForm(true);
        }
        
        private void Controller_ServiceChanged(object sender, EventArgs e)
        {
            UpdateServersMenu();
            LoadCurrentConfiguration();
        }

        private void Controller_EnableStatusChanged(object sender, EventArgs e)
        {
            if (Controller.GetConfigurationCopy().enabled)
            {
                ToggleConnectionStatusItem.Text = LocalizationManager.GetString("turn appgo off");
                ServersItem.Enabled = false;
            }
            else
            {
                ToggleConnectionStatusItem.Text = LocalizationManager.GetString("turn appgo on");
                ServersItem.Enabled = true;
            }
        }

        private void Controller_TrafficChanged(object sender, EventArgs e)
        {
        }

        private void Controller_LaunchAtLoginChanged(object sender, EventArgs e)
        {
            LaunchAtLoginItem.Checked = AutoStartup.Check();
        }

        private void Controller_ConfigChanged(object sender, EventArgs e)
        {
            LoadCurrentConfiguration();
            UpdateTrayIcon();
        }

        private void Controller_LanguageChanged(object sender, EventArgs e)
        {
            LoadMenu();
        }

        private void Controller_LoginChanged(object sender, EventArgs e)
        {
            LoadMenu();
        }

        private void LoadCurrentConfiguration()
        {
            AppPref config = Controller.GetConfigurationCopy();
            
            if (Controller.GetConfigurationCopy().enabled)
            {
                ConnectionStatusItem.Text = LocalizationManager.GetString("appgo: on");
                ToggleConnectionStatusItem.Text = LocalizationManager.GetString("turn appgo off");
            }
            else
            {
                ConnectionStatusItem.Text = LocalizationManager.GetString("appgo: off");
                ToggleConnectionStatusItem.Text = LocalizationManager.GetString("turn appgo on");
            }
            
            AGService service = config.GetCurrentService();
            if (service == null) return;
            
            LaunchAtLoginItem.Checked = AutoStartup.Check();
        }

        #region MenuItems and MenuGroups

        private MenuItem CreateMenuItem(string text, EventHandler click)
        {
            return CreateMenuItem(text, click, true);
        }

        private MenuItem CreateMenuItem(string text, EventHandler click, bool enabled)
        {
            MenuItem item = new MenuItem(LocalizationManager.GetString(text), click);
            item.Enabled = enabled;
            return item;
        }

        private MenuItem CreateMenuGroup(string text, MenuItem[] items)
        {
            return new MenuItem(LocalizationManager.GetString(text), items);
        }

        private void LoadMenu()
        {
            if (MainMenu != null)
            {
                MainMenu.MenuItems.Clear();
                MainMenu = null;
            }

            MainMenu = new ContextMenu();

            ConnectionStatusItem = CreateMenuItem(LocalizationManager.GetString("appgo: on"), null, false);
            ToggleConnectionStatusItem = CreateMenuItem(LocalizationManager.GetString("turn appgo on"), new EventHandler(this.ToggleConnectionItem_Click));
            //new MenuItem("-"),
            ServersItem = CreateMenuGroup(LocalizationManager.GetString("servers"), new MenuItem[] { });
            UpdateServersMenu();
            //new MenuItem("-"),
            LaunchAtLoginItem = CreateMenuItem(LocalizationManager.GetString("launch at login"), new EventHandler(this.LaunchAtLoginItem_Click));            
            QuitItem = CreateMenuItem(LocalizationManager.GetString("quit"), new EventHandler(this.Quit_Click));

            AppPref config = Controller.GetConfigurationCopy();
            if (config.logined)
            {
                MainMenu.MenuItems.Add(ConnectionStatusItem);
                MainMenu.MenuItems.Add(ToggleConnectionStatusItem);
                MainMenu.MenuItems.Add("-");
                MainMenu.MenuItems.Add("-");
                MainMenu.MenuItems.Add(ServersItem);
                MainMenu.MenuItems.Add("-");
                MainMenu.MenuItems.Add(LaunchAtLoginItem);                
                MainMenu.MenuItems.Add(QuitItem);
            }
            else
            {
                MainMenu.MenuItems.Add(LaunchAtLoginItem);
                MainMenu.MenuItems.Add(QuitItem);
            }
            

            if (_NotifyIcon != null)
                _NotifyIcon.ContextMenu = MainMenu;

        }

        private void UpdateServersMenu()
        {
            ServersItem.MenuItems.Clear();
            
            AppPref configuration = Controller.GetConfigurationCopy();
            if (configuration.services == null) return;

            for (int i = 0; i < configuration.services.Count; i++)
            {
                var server = configuration.services[i];

                MenuItem item = new MenuItem(server.FriendlyName());
                item.Tag = i;
                item.Click += AServerItem_Click;
                ServersItem.MenuItems.Add(i, item);
            }

            foreach (MenuItem item in ServersItem.MenuItems)
            {
                if (item.Tag != null && (item.Tag.ToString() == configuration.index.ToString()))
                {
                    item.Checked = true;
                }
            }
        }

        #endregion

        #region Tray Icon

        private void UpdateTrayIcon()
        {
            int dpi;
            Graphics graphics = Graphics.FromHwnd(IntPtr.Zero);
            dpi = (int)graphics.DpiX;
            graphics.Dispose();
            icon_connected = null;
            icon_disconnected = null;
            if (dpi < 97)
            {
                // dpi = 96;
                icon_connected = Resources.menu_icon_16;
                icon_disconnected = Resources.menu_icon_disabled_16;
            }
            else if (dpi < 121)
            {
                // dpi = 120;
                icon_connected = Resources.menu_icon_20;
                icon_disconnected = Resources.menu_icon_disabled_20;
            }
            else
            {
                icon_connected = Resources.menu_icon_24;
                icon_disconnected = Resources.menu_icon_disabled_24;
            }
            AppPref config = Controller.GetConfigurationCopy();
            bool enabled = config.enabled;
            
            icon_current = enabled ? icon_connected : icon_disconnected;
            _NotifyIcon.Icon = Icon.FromHandle(icon_current.GetHicon());

            AGService currentService = Controller.GetConfigurationCopy().GetCurrentService();
            string ruleMode = Controller.GetConfigurationCopy().ruleMode;

            string text = LocalizationManager.GetString("app version");
            if (currentService != null)
            {
                string countryName = CountryTemplate.GetCountryName(currentService.country.name);
                text += "\n" + (enabled ? LocalizationManager.GetString("appgo: on") : LocalizationManager.GetString("appgo: off"));
                text += (enabled ? ("\n" + LocalizationManager.GetString("server") + ": " + countryName) : "");
                if (text.Length > 127)
                {
                    text = text.Substring(0, 126 - 3) + "...";
                }
            }
                        
            ViewUtils.SetNotifyIconText(_NotifyIcon, text);
        }

        #endregion

        private void ShowMainForm(bool init)
        {
            if (MainForm != null)
            {
                MainForm.Show();
                MainForm.Activate();
            }
            else
            {
                MainForm = new MainForm(this);
                MainForm.Show();
                MainForm.Activate();
                MainForm.FormClosed += MainForm_FormClosed;
            }

            if (init)
            {
                SplashView = new SplashViewControl(this);
                PushView(SplashView);
            }            
        }

        public void ShowLoginView()
        {
            MainForm.Controls.Clear();
            LoginView = new LoginViewControl(this);
            PushView(LoginView);
        }

        public void ShowSignUpView()
        {
            SignUpView = new SignUpViewControl(this);
            PushView(SignUpView);
        }

        public void ShowMainView()
        {
            MainForm.Controls.Clear();

            MainView = new MainViewControl(this);
            PushView(MainView);
        }

        public void ShowForgotPasswordView(bool ModifyMode = false)
        {
            ForgotPasswordView = new ForgotPasswordViewControl(this, ModifyMode);
            PushView(ForgotPasswordView);
        }

        public void ShowCountryListView(CountryListViewControl.CountrySelected CountrySelected, CountryInfo CurrentSelectedCountry)
        {
            CountryListView = new CountryListViewControl(this);
            CountryListView.CountrySelectedDelegate = CountrySelected;
            CountryListView.SelectedCountry = CurrentSelectedCountry;
            PushView(CountryListView);
        }

        public void ShowTermsOfUseView()
        {
            TermsOfUseView = new TermsOfUseViewControl(this);
            PushView(TermsOfUseView);
        }

        public void ShowAccountView()
        {
            AccountView = new AccountViewControl(this);
            PushView(AccountView);
        }

        public void ShowShopView()
        {
            ShopView = new ShopViewControl(this);
            PushView(ShopView);
        }

        public void ShowSettingsView()
        {
            SettingsView = new SettingsViewControl(this);
            PushView(SettingsView);
        }

        public void ShowNotificationView()
        {
            NotificationView = new NotificationViewControl(this);
            PushView(NotificationView);
        }

        public void ShowFeedbackView()
        {
            FeedbackView = new FeedbackViewControl(this);
            PushView(FeedbackView);
        }

        public void ShowAboutUsView()
        {
            AboutUsView = new AboutUsViewControl(this);
            PushView(AboutUsView);
        }

        public void ShowServiceListView(AGService Service, ServiceSelectionViewControl.ServiceSelected ServiceSelectedDelegate)
        {
            ServiceListView = new ServiceSelectionViewControl(this, Service, ServiceSelectedDelegate);
            PushView(ServiceListView);
        }

        public void PushView(UserControl view)
        {
            MainForm.Controls.Add(view);

            if (MainForm.Controls.Count > 1)
            {
                MainForm.Controls[MainForm.Controls.Count - 2].Visible = false;
            }
        }

        public void PopBackToPreviousView()
        {
            if (MainForm.Controls.Count > 0)
            {
                if (MainForm.Controls.Count > 1)
                {
                    MainForm.Controls[MainForm.Controls.Count - 2].Visible = true;
                }

                MainForm.Controls.RemoveAt(MainForm.Controls.Count - 1);
            }
        }

        public void CloseMainForm()
        {
            MainForm.Hide();
            if (_isFirstRun)
            {
                ShowFirstTimeBalloon();
                _isFirstRun = false;
            }
        }

        public void MinimizeMainForm()
        {
            MainForm.WindowState = FormWindowState.Minimized;
        }

        
        void MainForm_FormClosed(object sender, FormClosedEventArgs e)
        {
            MainForm.Dispose();
            MainForm = null;
            Utils.ReleaseMemory(true);
            if (_isFirstRun)
            {
                ShowFirstTimeBalloon();
                _isFirstRun = false;
            }
        }

        private void AServerItem_Click(object sender, EventArgs e)
        {
            MenuItem item = (MenuItem)sender;
            Controller.SelectServerIndex((int)item.Tag);
        }
        
        private void ToggleConnectionItem_Click(object sender, EventArgs e)
        {
            AGService currentServer = Controller.GetConfigurationCopy().GetCurrentService();
            string ruleMode = Controller.GetConfigurationCopy().ruleMode;

            if (currentServer == null)
            {
                _NotifyIcon.BalloonTipTitle = LocalizationManager.GetString("AppGo");
                _NotifyIcon.BalloonTipText = LocalizationManager.GetString("please select vpn server.");
                _NotifyIcon.BalloonTipIcon = ToolTipIcon.Error;
                _NotifyIcon.ShowBalloonTip(0);
                return;
            }

            if (currentServer.expire_time.CompareTo(DateTime.Now) < 0)
            {
                _NotifyIcon.BalloonTipTitle = LocalizationManager.GetString("AppGo");
                _NotifyIcon.BalloonTipText = LocalizationManager.GetString("your vpn server is expired now.");
                _NotifyIcon.BalloonTipIcon = ToolTipIcon.Error;
                _NotifyIcon.ShowBalloonTip(0);
                return;
            }
                        
            Controller.ToggleEnable(!Controller.GetConfigurationCopy().enabled);
        }

        private void LaunchAtLoginItem_Click(object sender, EventArgs e)
        {
            Controller.ToggleLaunchAtLogin(!LaunchAtLoginItem.Checked);
        }

        private void Quit_Click(object sender, EventArgs e)
        {
            Controller.Stop();
            _NotifyIcon.Visible = false;
            Application.Exit();
        }

        private void NotifyIcon_DoubleClick(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
            {
                ShowMainForm(false);
            }
        }

        private void ShowFirstTimeBalloon()
        {
            _NotifyIcon.BalloonTipTitle = LocalizationManager.GetString("AppGo is here");
            _NotifyIcon.BalloonTipText = LocalizationManager.GetString("You can turn on/off AppGo in the context menu");
            _NotifyIcon.BalloonTipIcon = ToolTipIcon.Info;
            _NotifyIcon.ShowBalloonTip(0);
        }

        private async void GetBaseUrl()
        {
            HttpWebRequest request = WebRequest.Create(API.BASE_URL) as HttpWebRequest;
            using (HttpWebResponse response = request.GetResponse() as HttpWebResponse)  
            {
                StreamReader reader = new StreamReader(response.GetResponseStream());
                API.SERVICE_URL = reader.ReadToEnd().Replace("\n", "");

                AppPref config = Controller.GetConfigurationCopy();
                if (config.phoneNumber.IsNullOrEmpty() || config.password.IsNullOrEmpty())
                    PushView(LoginView);
                else
                {
                    using (WebClientCert client = new WebClientCert())
                    {
                        client.Headers.Add(new NameValueCollection()
                            {
                                { "Accept", API.HEADER_ACCEPT },
                                { "Content-Language", LocalizationManager.CurrentLanguage }
                            });

                        try
                        {
                            byte[] response2 = await client.UploadValuesTaskAsync(
                                API.Url("login"),
                                WebRequestMethods.Http.Post,
                                new NameValueCollection()
                                    {
                                { "username", config.phoneNumber },
                                { "password", config.password },
                                { "client_id", API.CLIENT_ID },
                                { "client_secret", API.CLIENT_SECRET },
                                { "grant_type", "password" }
                                    }
                                );

                            HttpStatusCode code = client.StatusCode;
                            string description = client.StatusDescription;
                            if (code == 0)
                            {
                                var dict = JsonConvert.DeserializeObject<Dictionary<string, string>>(System.Text.Encoding.UTF8.GetString(response2));
                                Controller.SetTokenType(dict["token_type"]);
                                Controller.SetAccessToken(dict["access_token"]);
                                Controller.SetExpiresIn(int.Parse(dict["expires_in"]));
                                Controller.SetRefreshToken(dict["refresh_token"]);
                                PushView(MainView);
                            }
                            else
                                PushView(LoginView);
                        }
                        catch (Exception ex)
                        {
                            PushView(LoginView);
                        }
                    }
                }
            }
        }

    }
}
