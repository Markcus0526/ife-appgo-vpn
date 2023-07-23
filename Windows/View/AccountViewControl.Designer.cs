namespace AppGo.View
{
    partial class AccountViewControl
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
            this.UserInfoPanel = new AppGo.View.CustomControls.AGPanel();
            this.LevelValueButton = new System.Windows.Forms.Button();
            this.LevelLabel = new AppGo.View.CustomControls.AGLabel();
            this.MiscellaneousLabel = new AppGo.View.CustomControls.AGLabel();
            this.PhoneNumberLabel = new AppGo.View.CustomControls.AGLabel();
            this.PhonePictureBox = new AppGo.View.CustomControls.AGPictureBox();
            this.UsernameLabel = new AppGo.View.CustomControls.AGLabel();
            this.AppIconPictureBox = new AppGo.View.CustomControls.AGPictureBox();
            this.TitleBarControl = new AppGo.View.CustomControls.AGTitleBarControl();
            this.FeedbackButton = new AppGo.View.CustomControls.AGImageAboveLabelButton();
            this.OfficialWebsiteButton = new AppGo.View.CustomControls.AGImageAboveLabelButton();
            this.AboutButton = new AppGo.View.CustomControls.AGImageAboveLabelButton();
            this.ChangePasswordButton = new AppGo.View.CustomControls.AGImageAboveLabelButton();
            this.LogoutButton = new AppGo.View.CustomControls.AGImageAboveLabelButton();
            this.UserInfoPanel.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.PhonePictureBox)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.AppIconPictureBox)).BeginInit();
            this.SuspendLayout();
            // 
            // UserInfoPanel
            // 
            this.UserInfoPanel.BackgroundImage = global::AppGo.Properties.Resources.ic_network_usage_background;
            this.UserInfoPanel.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.UserInfoPanel.Controls.Add(this.LevelValueButton);
            this.UserInfoPanel.Controls.Add(this.LevelLabel);
            this.UserInfoPanel.Controls.Add(this.MiscellaneousLabel);
            this.UserInfoPanel.Controls.Add(this.PhoneNumberLabel);
            this.UserInfoPanel.Controls.Add(this.PhonePictureBox);
            this.UserInfoPanel.Controls.Add(this.UsernameLabel);
            this.UserInfoPanel.Controls.Add(this.AppIconPictureBox);
            this.UserInfoPanel.Location = new System.Drawing.Point(25, 79);
            this.UserInfoPanel.Name = "UserInfoPanel";
            this.UserInfoPanel.Size = new System.Drawing.Size(330, 170);
            this.UserInfoPanel.TabIndex = 1;
            // 
            // LevelValueButton
            // 
            this.LevelValueButton.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(88)))), ((int)(((byte)(199)))), ((int)(((byte)(255)))));
            this.LevelValueButton.BackgroundImage = global::AppGo.Properties.Resources.ic_level_background;
            this.LevelValueButton.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.LevelValueButton.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(88)))), ((int)(((byte)(199)))), ((int)(((byte)(255)))));
            this.LevelValueButton.FlatAppearance.BorderSize = 0;
            this.LevelValueButton.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(88)))), ((int)(((byte)(199)))), ((int)(((byte)(255)))));
            this.LevelValueButton.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(88)))), ((int)(((byte)(199)))), ((int)(((byte)(255)))));
            this.LevelValueButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.LevelValueButton.Font = new System.Drawing.Font("Microsoft Sans Serif", 6.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.LevelValueButton.ForeColor = System.Drawing.Color.White;
            this.LevelValueButton.Location = new System.Drawing.Point(275, 133);
            this.LevelValueButton.Margin = new System.Windows.Forms.Padding(0);
            this.LevelValueButton.Name = "LevelValueButton";
            this.LevelValueButton.Size = new System.Drawing.Size(35, 19);
            this.LevelValueButton.TabIndex = 8;
            this.LevelValueButton.TabStop = false;
            this.LevelValueButton.UseVisualStyleBackColor = false;
            // 
            // LevelLabel
            // 
            this.LevelLabel.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(88)))), ((int)(((byte)(199)))), ((int)(((byte)(255)))));
            this.LevelLabel.ForeColor = System.Drawing.Color.White;
            this.LevelLabel.Location = new System.Drawing.Point(229, 136);
            this.LevelLabel.Name = "LevelLabel";
            this.LevelLabel.Size = new System.Drawing.Size(35, 13);
            this.LevelLabel.TabIndex = 7;
            this.LevelLabel.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // MiscellaneousLabel
            // 
            this.MiscellaneousLabel.AutoSize = true;
            this.MiscellaneousLabel.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(88)))), ((int)(((byte)(199)))), ((int)(((byte)(255)))));
            this.MiscellaneousLabel.ForeColor = System.Drawing.Color.White;
            this.MiscellaneousLabel.Location = new System.Drawing.Point(136, 136);
            this.MiscellaneousLabel.Name = "MiscellaneousLabel";
            this.MiscellaneousLabel.Size = new System.Drawing.Size(0, 13);
            this.MiscellaneousLabel.TabIndex = 6;
            // 
            // PhoneNumberLabel
            // 
            this.PhoneNumberLabel.AutoSize = true;
            this.PhoneNumberLabel.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(88)))), ((int)(((byte)(199)))), ((int)(((byte)(255)))));
            this.PhoneNumberLabel.ForeColor = System.Drawing.Color.White;
            this.PhoneNumberLabel.Location = new System.Drawing.Point(35, 137);
            this.PhoneNumberLabel.Name = "PhoneNumberLabel";
            this.PhoneNumberLabel.Size = new System.Drawing.Size(0, 13);
            this.PhoneNumberLabel.TabIndex = 5;
            // 
            // PhonePictureBox
            // 
            this.PhonePictureBox.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(88)))), ((int)(((byte)(199)))), ((int)(((byte)(255)))));
            this.PhonePictureBox.Enabled = false;
            this.PhonePictureBox.Image = global::AppGo.Properties.Resources.ic_phone;
            this.PhonePictureBox.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.High;
            this.PhonePictureBox.Location = new System.Drawing.Point(15, 136);
            this.PhonePictureBox.Name = "PhonePictureBox";
            this.PhonePictureBox.Size = new System.Drawing.Size(15, 15);
            this.PhonePictureBox.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.PhonePictureBox.TabIndex = 4;
            this.PhonePictureBox.TabStop = false;
            // 
            // UsernameLabel
            // 
            this.UsernameLabel.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(88)))), ((int)(((byte)(199)))), ((int)(((byte)(255)))));
            this.UsernameLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.UsernameLabel.ForeColor = System.Drawing.Color.White;
            this.UsernameLabel.Location = new System.Drawing.Point(0, 90);
            this.UsernameLabel.Name = "UsernameLabel";
            this.UsernameLabel.Size = new System.Drawing.Size(330, 25);
            this.UsernameLabel.TabIndex = 3;
            this.UsernameLabel.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // AppIconPictureBox
            // 
            this.AppIconPictureBox.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.AppIconPictureBox.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(88)))), ((int)(((byte)(199)))), ((int)(((byte)(255)))));
            this.AppIconPictureBox.BackgroundImageLayout = System.Windows.Forms.ImageLayout.None;
            this.AppIconPictureBox.Enabled = false;
            this.AppIconPictureBox.Image = global::AppGo.Properties.Resources.ic_appicon_mark;
            this.AppIconPictureBox.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.High;
            this.AppIconPictureBox.Location = new System.Drawing.Point(135, 18);
            this.AppIconPictureBox.Margin = new System.Windows.Forms.Padding(0);
            this.AppIconPictureBox.Name = "AppIconPictureBox";
            this.AppIconPictureBox.Size = new System.Drawing.Size(60, 60);
            this.AppIconPictureBox.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.AppIconPictureBox.TabIndex = 2;
            this.AppIconPictureBox.TabStop = false;
            // 
            // TitleBarControl
            // 
            this.TitleBarControl.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(88)))), ((int)(((byte)(199)))), ((int)(((byte)(255)))));
            this.TitleBarControl.Location = new System.Drawing.Point(0, 0);
            this.TitleBarControl.Name = "TitleBarControl";
            this.TitleBarControl.Size = new System.Drawing.Size(380, 50);
            this.TitleBarControl.TabIndex = 0;
            this.TitleBarControl.Title = "Account";
            // 
            // FeedbackButton
            // 
            this.FeedbackButton.BackColor = System.Drawing.Color.Transparent;
            this.FeedbackButton.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.FeedbackButton.Image = global::AppGo.Properties.Resources.ic_faq;
            this.FeedbackButton.LabelText = "Feedback";
            this.FeedbackButton.Location = new System.Drawing.Point(143, 305);
            this.FeedbackButton.Margin = new System.Windows.Forms.Padding(0);
            this.FeedbackButton.Name = "FeedbackButton";
            this.FeedbackButton.Size = new System.Drawing.Size(95, 80);
            this.FeedbackButton.TabIndex = 3;
            this.FeedbackButton.Click += new System.EventHandler(this.FeedbackButton_Click);
            // 
            // OfficialWebsiteButton
            // 
            this.OfficialWebsiteButton.BackColor = System.Drawing.Color.Transparent;
            this.OfficialWebsiteButton.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.OfficialWebsiteButton.Image = global::AppGo.Properties.Resources.ic_feedback;
            this.OfficialWebsiteButton.LabelText = "Official Website";
            this.OfficialWebsiteButton.Location = new System.Drawing.Point(256, 305);
            this.OfficialWebsiteButton.Margin = new System.Windows.Forms.Padding(0);
            this.OfficialWebsiteButton.Name = "OfficialWebsiteButton";
            this.OfficialWebsiteButton.Size = new System.Drawing.Size(95, 80);
            this.OfficialWebsiteButton.TabIndex = 4;
            this.OfficialWebsiteButton.Click += new System.EventHandler(this.OfficialWebsiteButton_Click);
            // 
            // AboutButton
            // 
            this.AboutButton.BackColor = System.Drawing.Color.Transparent;
            this.AboutButton.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.AboutButton.Image = global::AppGo.Properties.Resources.ic_about_us;
            this.AboutButton.LabelText = "About";
            this.AboutButton.Location = new System.Drawing.Point(87, 425);
            this.AboutButton.Margin = new System.Windows.Forms.Padding(0);
            this.AboutButton.Name = "AboutButton";
            this.AboutButton.Size = new System.Drawing.Size(95, 80);
            this.AboutButton.TabIndex = 5;
            this.AboutButton.Click += new System.EventHandler(this.AboutButton_Click);
            // 
            // ChangePasswordButton
            // 
            this.ChangePasswordButton.BackColor = System.Drawing.Color.Transparent;
            this.ChangePasswordButton.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.ChangePasswordButton.Image = global::AppGo.Properties.Resources.ic_change_password;
            this.ChangePasswordButton.LabelText = "Password";
            this.ChangePasswordButton.Location = new System.Drawing.Point(25, 305);
            this.ChangePasswordButton.Margin = new System.Windows.Forms.Padding(0);
            this.ChangePasswordButton.Name = "ChangePasswordButton";
            this.ChangePasswordButton.Size = new System.Drawing.Size(95, 80);
            this.ChangePasswordButton.TabIndex = 6;
            this.ChangePasswordButton.Click += new System.EventHandler(this.ChangePasswordButton_Click);
            // 
            // LogoutButton
            // 
            this.LogoutButton.BackColor = System.Drawing.Color.Transparent;
            this.LogoutButton.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.LogoutButton.Image = global::AppGo.Properties.Resources.ic_logout;
            this.LogoutButton.LabelText = "Logout";
            this.LogoutButton.Location = new System.Drawing.Point(197, 425);
            this.LogoutButton.Margin = new System.Windows.Forms.Padding(0);
            this.LogoutButton.Name = "LogoutButton";
            this.LogoutButton.Size = new System.Drawing.Size(95, 80);
            this.LogoutButton.TabIndex = 7;
            this.LogoutButton.Click += new System.EventHandler(this.LogoutButton_Click);
            // 
            // AccountViewControl
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.White;
            this.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.Controls.Add(this.LogoutButton);
            this.Controls.Add(this.ChangePasswordButton);
            this.Controls.Add(this.AboutButton);
            this.Controls.Add(this.OfficialWebsiteButton);
            this.Controls.Add(this.FeedbackButton);
            this.Controls.Add(this.UserInfoPanel);
            this.Controls.Add(this.TitleBarControl);
            this.Name = "AccountViewControl";
            this.Size = new System.Drawing.Size(380, 570);
            this.UserInfoPanel.ResumeLayout(false);
            this.UserInfoPanel.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.PhonePictureBox)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.AppIconPictureBox)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private CustomControls.AGTitleBarControl TitleBarControl;
        private CustomControls.AGPanel UserInfoPanel;
        private CustomControls.AGLabel UsernameLabel;
        private CustomControls.AGPictureBox AppIconPictureBox;
        private CustomControls.AGPictureBox PhonePictureBox;
        private CustomControls.AGLabel PhoneNumberLabel;
        private CustomControls.AGLabel LevelLabel;
        private CustomControls.AGLabel MiscellaneousLabel;
        private System.Windows.Forms.Button LevelValueButton;
        private CustomControls.AGImageAboveLabelButton FeedbackButton;
        private CustomControls.AGImageAboveLabelButton OfficialWebsiteButton;
        private CustomControls.AGImageAboveLabelButton AboutButton;
        private CustomControls.AGImageAboveLabelButton ChangePasswordButton;
        private CustomControls.AGImageAboveLabelButton LogoutButton;
    }
}
