namespace AppGo.View
{
    partial class MainViewControl
    {
        /// <summary> 
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary> 
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Component Designer generated code

        /// <summary> 
        /// Required method for Designer support - do not modify 
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(MainViewControl));
            this.NotificationLabel = new System.Windows.Forms.Label();
            this.AppTitlePictureBox = new AppGo.View.CustomControls.AGPictureBox();
            this.NotifyButton = new AppGo.View.CustomControls.AGImageLabelButton();
            this.NotificationButton = new AppGo.View.CustomControls.AGImageButton();
            this.SelectServiceButton = new AppGo.View.CustomControls.AGImageButton();
            this.ServiceListButton = new AppGo.View.CustomControls.AGServiceListButton();
            this.ServerLabel = new AppGo.View.CustomControls.AGLabel();
            this.SettingsButton = new AppGo.View.CustomControls.AGImageLabelButton();
            this.ShopButton = new AppGo.View.CustomControls.AGImageLabelButton();
            this.AccountButton = new AppGo.View.CustomControls.AGImageLabelButton();
            this.ConnectionStateLabel = new AppGo.View.CustomControls.AGLabel();
            this.MinimizeButton = new AppGo.View.CustomControls.AGImageButton();
            this.CloseButton = new AppGo.View.CustomControls.AGImageButton();
            this.panel1 = new AppGo.View.CustomControls.AGPanel();
            this.ConnectPictureBox = new AppGo.View.CustomControls.AGConnectPictureBox();
            this.DataQuotaLabel = new AppGo.View.CustomControls.AGLabel();
            this.DueTimeLabel = new AppGo.View.CustomControls.AGLabel();
            this.DueTimeValueLabel = new AppGo.View.CustomControls.AGLabel();
            this.DataQuotaValueLabel = new AppGo.View.CustomControls.AGLabel();
            this.DataQuotaProgressBar = new AppGo.View.CustomControls.AGProgressBar();
            this.NetworkUsagePanel = new AppGo.View.CustomControls.AGPanel();
            ((System.ComponentModel.ISupportInitialize)(this.AppTitlePictureBox)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.ConnectPictureBox)).BeginInit();
            this.NetworkUsagePanel.SuspendLayout();
            this.SuspendLayout();
            // 
            // NotificationLabel
            // 
            this.NotificationLabel.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(204)))), ((int)(((byte)(204)))), ((int)(((byte)(204)))));
            this.NotificationLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.NotificationLabel.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(55)))), ((int)(((byte)(150)))), ((int)(((byte)(198)))));
            this.NotificationLabel.Location = new System.Drawing.Point(55, 542);
            this.NotificationLabel.Name = "NotificationLabel";
            this.NotificationLabel.Size = new System.Drawing.Size(301, 18);
            this.NotificationLabel.TabIndex = 22;
            this.NotificationLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            this.NotificationLabel.Click += new System.EventHandler(this.NotificationLabel_Click);
            // 
            // AppTitlePictureBox
            // 
            this.AppTitlePictureBox.BackColor = System.Drawing.Color.Transparent;
            this.AppTitlePictureBox.Enabled = false;
            this.AppTitlePictureBox.Image = global::AppGo.Properties.Resources.ic_version_title_white;
            this.AppTitlePictureBox.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.High;
            this.AppTitlePictureBox.Location = new System.Drawing.Point(12, 11);
            this.AppTitlePictureBox.Margin = new System.Windows.Forms.Padding(0);
            this.AppTitlePictureBox.Name = "AppTitlePictureBox";
            this.AppTitlePictureBox.Size = new System.Drawing.Size(84, 21);
            this.AppTitlePictureBox.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.AppTitlePictureBox.TabIndex = 3;
            this.AppTitlePictureBox.TabStop = false;
            // 
            // NotifyButton
            // 
            this.NotifyButton.BackColor = System.Drawing.Color.Transparent;
            this.NotifyButton.Image = global::AppGo.Properties.Resources.ic_notification;
            this.NotifyButton.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.Default;
            this.NotifyButton.LabelText = "Notification";
            this.NotifyButton.Location = new System.Drawing.Point(40, 435);
            this.NotifyButton.Margin = new System.Windows.Forms.Padding(0);
            this.NotifyButton.Name = "NotifyButton";
            this.NotifyButton.Size = new System.Drawing.Size(129, 32);
            this.NotifyButton.TabIndex = 37;
            this.NotifyButton.Click += new System.EventHandler(this.NotifyButton_Click);
            // 
            // NotificationButton
            // 
            this.NotificationButton.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(204)))), ((int)(((byte)(204)))), ((int)(((byte)(204)))));
            this.NotificationButton.BackgroundImage = global::AppGo.Properties.Resources.ic_bell;
            this.NotificationButton.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Zoom;
            this.NotificationButton.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(204)))), ((int)(((byte)(204)))), ((int)(((byte)(204)))));
            this.NotificationButton.FlatAppearance.BorderSize = 0;
            this.NotificationButton.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(204)))), ((int)(((byte)(204)))), ((int)(((byte)(204)))));
            this.NotificationButton.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(204)))), ((int)(((byte)(204)))), ((int)(((byte)(204)))));
            this.NotificationButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.NotificationButton.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.Default;
            this.NotificationButton.Location = new System.Drawing.Point(12, 539);
            this.NotificationButton.Name = "NotificationButton";
            this.NotificationButton.Size = new System.Drawing.Size(25, 25);
            this.NotificationButton.TabIndex = 35;
            this.NotificationButton.UseVisualStyleBackColor = false;
            this.NotificationButton.Click += new System.EventHandler(this.NotificationButton_Click);
            // 
            // SelectServiceButton
            // 
            this.SelectServiceButton.BackgroundImage = global::AppGo.Properties.Resources.ic_server;
            this.SelectServiceButton.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Zoom;
            this.SelectServiceButton.FlatAppearance.BorderColor = System.Drawing.Color.White;
            this.SelectServiceButton.FlatAppearance.BorderSize = 0;
            this.SelectServiceButton.FlatAppearance.MouseDownBackColor = System.Drawing.Color.White;
            this.SelectServiceButton.FlatAppearance.MouseOverBackColor = System.Drawing.Color.White;
            this.SelectServiceButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.SelectServiceButton.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.Default;
            this.SelectServiceButton.Location = new System.Drawing.Point(319, 230);
            this.SelectServiceButton.Name = "SelectServiceButton";
            this.SelectServiceButton.Size = new System.Drawing.Size(30, 30);
            this.SelectServiceButton.TabIndex = 31;
            this.SelectServiceButton.UseVisualStyleBackColor = true;
            this.SelectServiceButton.Click += new System.EventHandler(this.SelectServiceButton_Click);
            // 
            // ServiceListButton
            // 
            this.ServiceListButton.BackColor = System.Drawing.Color.Transparent;
            this.ServiceListButton.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("ServiceListButton.BackgroundImage")));
            this.ServiceListButton.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.ServiceListButton.DownArrowImage = ((System.Drawing.Image)(resources.GetObject("ServiceListButton.DownArrowImage")));
            this.ServiceListButton.Location = new System.Drawing.Point(97, 232);
            this.ServiceListButton.Name = "ServiceListButton";
            this.ServiceListButton.Service = null;
            this.ServiceListButton.Size = new System.Drawing.Size(208, 30);
            this.ServiceListButton.TabIndex = 30;
            this.ServiceListButton.TextColor = System.Drawing.Color.White;
            this.ServiceListButton.Click += new System.EventHandler(this.ServiceListButton_Click);
            // 
            // ServerLabel
            // 
            this.ServerLabel.AutoSize = true;
            this.ServerLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.ServerLabel.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(55)))), ((int)(((byte)(150)))), ((int)(((byte)(198)))));
            this.ServerLabel.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft;
            this.ServerLabel.Location = new System.Drawing.Point(24, 240);
            this.ServerLabel.Name = "ServerLabel";
            this.ServerLabel.Size = new System.Drawing.Size(42, 15);
            this.ServerLabel.TabIndex = 28;
            this.ServerLabel.Text = "Server";
            // 
            // SettingsButton
            // 
            this.SettingsButton.BackColor = System.Drawing.Color.Transparent;
            this.SettingsButton.Image = global::AppGo.Properties.Resources.ic_settings;
            this.SettingsButton.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.Default;
            this.SettingsButton.LabelText = "Settings";
            this.SettingsButton.Location = new System.Drawing.Point(40, 480);
            this.SettingsButton.Margin = new System.Windows.Forms.Padding(0);
            this.SettingsButton.Name = "SettingsButton";
            this.SettingsButton.Size = new System.Drawing.Size(129, 32);
            this.SettingsButton.TabIndex = 25;
            this.SettingsButton.Click += new System.EventHandler(this.SettingsButton_Click);
            // 
            // ShopButton
            // 
            this.ShopButton.BackColor = System.Drawing.Color.Transparent;
            this.ShopButton.Image = global::AppGo.Properties.Resources.ic_shop;
            this.ShopButton.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.Default;
            this.ShopButton.LabelText = "Shop";
            this.ShopButton.Location = new System.Drawing.Point(207, 435);
            this.ShopButton.Margin = new System.Windows.Forms.Padding(0);
            this.ShopButton.Name = "ShopButton";
            this.ShopButton.Size = new System.Drawing.Size(137, 32);
            this.ShopButton.TabIndex = 24;
            this.ShopButton.Click += new System.EventHandler(this.ShopButton_Click);
            // 
            // AccountButton
            // 
            this.AccountButton.BackColor = System.Drawing.Color.Transparent;
            this.AccountButton.Image = global::AppGo.Properties.Resources.ic_person;
            this.AccountButton.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.Default;
            this.AccountButton.LabelText = "Account";
            this.AccountButton.Location = new System.Drawing.Point(206, 480);
            this.AccountButton.Margin = new System.Windows.Forms.Padding(0);
            this.AccountButton.Name = "AccountButton";
            this.AccountButton.Size = new System.Drawing.Size(129, 32);
            this.AccountButton.TabIndex = 23;
            this.AccountButton.Click += new System.EventHandler(this.AccountButton_Click);
            // 
            // ConnectionStateLabel
            // 
            this.ConnectionStateLabel.BackColor = System.Drawing.Color.Transparent;
            this.ConnectionStateLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.ConnectionStateLabel.ForeColor = System.Drawing.Color.White;
            this.ConnectionStateLabel.Location = new System.Drawing.Point(0, 133);
            this.ConnectionStateLabel.Name = "ConnectionStateLabel";
            this.ConnectionStateLabel.Size = new System.Drawing.Size(380, 27);
            this.ConnectionStateLabel.TabIndex = 5;
            this.ConnectionStateLabel.Text = "Tap to Connect";
            this.ConnectionStateLabel.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // MinimizeButton
            // 
            this.MinimizeButton.BackColor = System.Drawing.Color.Transparent;
            this.MinimizeButton.BackgroundImage = global::AppGo.Properties.Resources.ic_minimize;
            this.MinimizeButton.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Zoom;
            this.MinimizeButton.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(88)))), ((int)(((byte)(199)))), ((int)(((byte)(255)))));
            this.MinimizeButton.FlatAppearance.BorderSize = 0;
            this.MinimizeButton.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(88)))), ((int)(((byte)(199)))), ((int)(((byte)(255)))));
            this.MinimizeButton.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(88)))), ((int)(((byte)(199)))), ((int)(((byte)(255)))));
            this.MinimizeButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.MinimizeButton.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.Default;
            this.MinimizeButton.Location = new System.Drawing.Point(312, 16);
            this.MinimizeButton.Margin = new System.Windows.Forms.Padding(0);
            this.MinimizeButton.Name = "MinimizeButton";
            this.MinimizeButton.Size = new System.Drawing.Size(20, 20);
            this.MinimizeButton.TabIndex = 20;
            this.MinimizeButton.TabStop = false;
            this.MinimizeButton.UseVisualStyleBackColor = false;
            this.MinimizeButton.Click += new System.EventHandler(this.MinimizeButton_Click);
            // 
            // CloseButton
            // 
            this.CloseButton.BackColor = System.Drawing.Color.Transparent;
            this.CloseButton.BackgroundImage = global::AppGo.Properties.Resources.ic_close;
            this.CloseButton.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Zoom;
            this.CloseButton.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(88)))), ((int)(((byte)(199)))), ((int)(((byte)(255)))));
            this.CloseButton.FlatAppearance.BorderSize = 0;
            this.CloseButton.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(88)))), ((int)(((byte)(199)))), ((int)(((byte)(255)))));
            this.CloseButton.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(88)))), ((int)(((byte)(199)))), ((int)(((byte)(255)))));
            this.CloseButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.CloseButton.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.Default;
            this.CloseButton.Location = new System.Drawing.Point(345, 15);
            this.CloseButton.Margin = new System.Windows.Forms.Padding(0);
            this.CloseButton.Name = "CloseButton";
            this.CloseButton.Size = new System.Drawing.Size(20, 20);
            this.CloseButton.TabIndex = 19;
            this.CloseButton.TabStop = false;
            this.CloseButton.UseVisualStyleBackColor = false;
            this.CloseButton.Click += new System.EventHandler(this.CloseButton_Click);
            // 
            // panel1
            // 
            this.panel1.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(204)))), ((int)(((byte)(204)))), ((int)(((byte)(204)))));
            this.panel1.Location = new System.Drawing.Point(0, 533);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(380, 37);
            this.panel1.TabIndex = 38;
            // 
            // ConnectPictureBox
            // 
            this.ConnectPictureBox.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Zoom;
            this.ConnectPictureBox.Image = global::AppGo.Properties.Resources.ic_disconnected;
            this.ConnectPictureBox.Location = new System.Drawing.Point(106, 3);
            this.ConnectPictureBox.Name = "ConnectPictureBox";
            this.ConnectPictureBox.Size = new System.Drawing.Size(173, 170);
            this.ConnectPictureBox.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.ConnectPictureBox.TabIndex = 40;
            this.ConnectPictureBox.TabStop = false;
            this.ConnectPictureBox.Click += new System.EventHandler(this.ConnectPictureBox_Click);
            // 
            // DataQuotaLabel
            // 
            this.DataQuotaLabel.AutoSize = true;
            this.DataQuotaLabel.BackColor = System.Drawing.Color.Transparent;
            this.DataQuotaLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.DataQuotaLabel.ForeColor = System.Drawing.Color.White;
            this.DataQuotaLabel.Location = new System.Drawing.Point(11, 15);
            this.DataQuotaLabel.Name = "DataQuotaLabel";
            this.DataQuotaLabel.Size = new System.Drawing.Size(69, 15);
            this.DataQuotaLabel.TabIndex = 0;
            this.DataQuotaLabel.Text = "Data Quota";
            // 
            // DueTimeLabel
            // 
            this.DueTimeLabel.AutoSize = true;
            this.DueTimeLabel.BackColor = System.Drawing.Color.Transparent;
            this.DueTimeLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.DueTimeLabel.ForeColor = System.Drawing.Color.White;
            this.DueTimeLabel.Location = new System.Drawing.Point(11, 81);
            this.DueTimeLabel.Name = "DueTimeLabel";
            this.DueTimeLabel.Size = new System.Drawing.Size(61, 15);
            this.DueTimeLabel.TabIndex = 1;
            this.DueTimeLabel.Text = "Due Time";
            // 
            // DueTimeValueLabel
            // 
            this.DueTimeValueLabel.BackColor = System.Drawing.Color.Transparent;
            this.DueTimeValueLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.DueTimeValueLabel.ForeColor = System.Drawing.Color.White;
            this.DueTimeValueLabel.Location = new System.Drawing.Point(186, 82);
            this.DueTimeValueLabel.Name = "DueTimeValueLabel";
            this.DueTimeValueLabel.Size = new System.Drawing.Size(131, 15);
            this.DueTimeValueLabel.TabIndex = 3;
            this.DueTimeValueLabel.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // DataQuotaValueLabel
            // 
            this.DataQuotaValueLabel.BackColor = System.Drawing.Color.Transparent;
            this.DataQuotaValueLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.DataQuotaValueLabel.ForeColor = System.Drawing.Color.White;
            this.DataQuotaValueLabel.Location = new System.Drawing.Point(184, 16);
            this.DataQuotaValueLabel.Name = "DataQuotaValueLabel";
            this.DataQuotaValueLabel.Size = new System.Drawing.Size(133, 15);
            this.DataQuotaValueLabel.TabIndex = 4;
            this.DataQuotaValueLabel.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // DataQuotaProgressBar
            // 
            this.DataQuotaProgressBar.BackColor = System.Drawing.Color.Transparent;
            this.DataQuotaProgressBar.Location = new System.Drawing.Point(14, 46);
            this.DataQuotaProgressBar.Name = "DataQuotaProgressBar";
            this.DataQuotaProgressBar.Progress = 0;
            this.DataQuotaProgressBar.Size = new System.Drawing.Size(303, 15);
            this.DataQuotaProgressBar.TabIndex = 5;
            // 
            // NetworkUsagePanel
            // 
            this.NetworkUsagePanel.BackgroundImage = global::AppGo.Properties.Resources.ic_network_usage_background;
            this.NetworkUsagePanel.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.NetworkUsagePanel.Controls.Add(this.DataQuotaProgressBar);
            this.NetworkUsagePanel.Controls.Add(this.DataQuotaValueLabel);
            this.NetworkUsagePanel.Controls.Add(this.DueTimeValueLabel);
            this.NetworkUsagePanel.Controls.Add(this.DueTimeLabel);
            this.NetworkUsagePanel.Controls.Add(this.DataQuotaLabel);
            this.NetworkUsagePanel.Location = new System.Drawing.Point(24, 300);
            this.NetworkUsagePanel.Name = "NetworkUsagePanel";
            this.NetworkUsagePanel.Size = new System.Drawing.Size(332, 110);
            this.NetworkUsagePanel.TabIndex = 21;
            // 
            // MainViewControl
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.Transparent;
            this.BackgroundImage = global::AppGo.Properties.Resources.main_back;
            this.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.Controls.Add(this.AppTitlePictureBox);
            this.Controls.Add(this.NotifyButton);
            this.Controls.Add(this.NotificationButton);
            this.Controls.Add(this.SelectServiceButton);
            this.Controls.Add(this.ServiceListButton);
            this.Controls.Add(this.ServerLabel);
            this.Controls.Add(this.SettingsButton);
            this.Controls.Add(this.ShopButton);
            this.Controls.Add(this.AccountButton);
            this.Controls.Add(this.ConnectionStateLabel);
            this.Controls.Add(this.NotificationLabel);
            this.Controls.Add(this.NetworkUsagePanel);
            this.Controls.Add(this.MinimizeButton);
            this.Controls.Add(this.CloseButton);
            this.Controls.Add(this.panel1);
            this.Controls.Add(this.ConnectPictureBox);
            this.DoubleBuffered = true;
            this.Name = "MainViewControl";
            this.Size = new System.Drawing.Size(380, 570);
            ((System.ComponentModel.ISupportInitialize)(this.AppTitlePictureBox)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.ConnectPictureBox)).EndInit();
            this.NetworkUsagePanel.ResumeLayout(false);
            this.NetworkUsagePanel.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion
        private CustomControls.AGPictureBox AppTitlePictureBox;
        private CustomControls.AGImageLabelButton AccountButton;
        private CustomControls.AGImageButton MinimizeButton;
        private CustomControls.AGImageButton CloseButton;
        private CustomControls.AGImageLabelButton ShopButton;
        private CustomControls.AGImageLabelButton SettingsButton;
        private System.Windows.Forms.Label NotificationLabel;
        private CustomControls.AGLabel ConnectionStateLabel;
        private CustomControls.AGLabel ServerLabel;
        private CustomControls.AGServiceListButton ServiceListButton;
        private CustomControls.AGImageButton SelectServiceButton;
        private CustomControls.AGImageButton NotificationButton;
        private CustomControls.AGImageLabelButton NotifyButton;
        private CustomControls.AGPanel panel1;
        private CustomControls.AGConnectPictureBox ConnectPictureBox;
        private CustomControls.AGLabel DataQuotaLabel;
        private CustomControls.AGLabel DueTimeLabel;
        private CustomControls.AGLabel DueTimeValueLabel;
        private CustomControls.AGLabel DataQuotaValueLabel;
        private CustomControls.AGProgressBar DataQuotaProgressBar;
        private CustomControls.AGPanel NetworkUsagePanel;
    }
}
