namespace AppGo.View
{
    partial class SettingsViewControl
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
            this.LaunchAtLogInSettingControl = new AppGo.View.CustomControls.AGCheckboxSettingButton();
            this.TitleBarControl = new AppGo.View.CustomControls.AGTitleBarControl();
            this.LanguageSettingControl = new AppGo.View.CustomControls.AGLanguageListButton();
            this.ShareOverLANSettingControl = new AppGo.View.CustomControls.AGCheckboxSettingButton();
            this.SuspendLayout();
            // 
            // LaunchAtLogInSettingControl
            // 
            this.LaunchAtLogInSettingControl.Checked = false;
            this.LaunchAtLogInSettingControl.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.LaunchAtLogInSettingControl.Label = "Launch At Login";
            this.LaunchAtLogInSettingControl.Location = new System.Drawing.Point(24, 137);
            this.LaunchAtLogInSettingControl.Name = "LaunchAtLogInSettingControl";
            this.LaunchAtLogInSettingControl.Size = new System.Drawing.Size(330, 30);
            this.LaunchAtLogInSettingControl.TabIndex = 3;
            this.LaunchAtLogInSettingControl.Click += new System.EventHandler(this.LaunchAtLogInSettingControl_Click);
            // 
            // TitleBarControl
            // 
            this.TitleBarControl.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(88)))), ((int)(((byte)(199)))), ((int)(((byte)(255)))));
            this.TitleBarControl.Location = new System.Drawing.Point(0, 0);
            this.TitleBarControl.Name = "TitleBarControl";
            this.TitleBarControl.Size = new System.Drawing.Size(380, 50);
            this.TitleBarControl.TabIndex = 0;
            this.TitleBarControl.Title = "Settings";
            // 
            // LanguageSettingControl
            // 
            this.LanguageSettingControl.BackColor = System.Drawing.Color.Transparent;
            this.LanguageSettingControl.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.LanguageSettingControl.IsOpeningMenu = false;
            this.LanguageSettingControl.Language = "";
            this.LanguageSettingControl.Location = new System.Drawing.Point(24, 81);
            this.LanguageSettingControl.Margin = new System.Windows.Forms.Padding(4);
            this.LanguageSettingControl.Name = "LanguageSettingControl";
            this.LanguageSettingControl.Size = new System.Drawing.Size(330, 30);
            this.LanguageSettingControl.TabIndex = 4;
            this.LanguageSettingControl.Click += new System.EventHandler(this.LanguageSettingControl_Click);
            // 
            // ShareOverLANSettingControl
            // 
            this.ShareOverLANSettingControl.Checked = false;
            this.ShareOverLANSettingControl.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.ShareOverLANSettingControl.Label = "Launch At Login";
            this.ShareOverLANSettingControl.Location = new System.Drawing.Point(25, 195);
            this.ShareOverLANSettingControl.Name = "ShareOverLANSettingControl";
            this.ShareOverLANSettingControl.Size = new System.Drawing.Size(330, 30);
            this.ShareOverLANSettingControl.TabIndex = 5;
            this.ShareOverLANSettingControl.Visible = false;
            this.ShareOverLANSettingControl.Click += new System.EventHandler(this.ShareOverLANSettingControl_Click);
            // 
            // SettingsViewControl
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.White;
            this.Controls.Add(this.ShareOverLANSettingControl);
            this.Controls.Add(this.LanguageSettingControl);
            this.Controls.Add(this.LaunchAtLogInSettingControl);
            this.Controls.Add(this.TitleBarControl);
            this.Name = "SettingsViewControl";
            this.Size = new System.Drawing.Size(380, 570);
            this.ResumeLayout(false);

        }

        #endregion

        private CustomControls.AGTitleBarControl TitleBarControl;
        private CustomControls.AGCheckboxSettingButton LaunchAtLogInSettingControl;
        private CustomControls.AGLanguageListButton LanguageSettingControl;
        private CustomControls.AGCheckboxSettingButton ShareOverLANSettingControl;
    }
}
