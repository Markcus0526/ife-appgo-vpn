namespace AppGo.View.CustomControls
{
    partial class AGCheckboxSettingButton
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
            this.CheckToggleButton = new AppGo.View.CustomControls.AGToggleImageButton();
            this.SettingTitleLabel = new AppGo.View.CustomControls.AGLabel();
            this.SuspendLayout();
            // 
            // CheckToggleButton
            // 
            this.CheckToggleButton.BackColor = System.Drawing.Color.Transparent;
            this.CheckToggleButton.BackgroundImage = global::AppGo.Properties.Resources.ic_check_off;
            this.CheckToggleButton.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Zoom;
            this.CheckToggleButton.FlatAppearance.BorderSize = 0;
            this.CheckToggleButton.FlatAppearance.MouseDownBackColor = System.Drawing.Color.Transparent;
            this.CheckToggleButton.FlatAppearance.MouseOverBackColor = System.Drawing.Color.Transparent;
            this.CheckToggleButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.CheckToggleButton.Location = new System.Drawing.Point(285, 4);
            this.CheckToggleButton.Name = "CheckToggleButton";
            this.CheckToggleButton.NormalImage = global::AppGo.Properties.Resources.ic_check_off;
            this.CheckToggleButton.Selected = false;
            this.CheckToggleButton.SelectedImage = global::AppGo.Properties.Resources.ic_check_on;
            this.CheckToggleButton.Size = new System.Drawing.Size(20, 17);
            this.CheckToggleButton.TabIndex = 2;
            this.CheckToggleButton.UseVisualStyleBackColor = false;
            this.CheckToggleButton.Click += new System.EventHandler(this.CheckToggleButton_Click);
            // 
            // SettingTitleLabel
            // 
            this.SettingTitleLabel.BackColor = System.Drawing.Color.Transparent;
            this.SettingTitleLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.SettingTitleLabel.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(55)))), ((int)(((byte)(150)))), ((int)(((byte)(198)))));
            this.SettingTitleLabel.Location = new System.Drawing.Point(20, 0);
            this.SettingTitleLabel.Name = "SettingTitleLabel";
            this.SettingTitleLabel.Size = new System.Drawing.Size(200, 30);
            this.SettingTitleLabel.TabIndex = 1;
            this.SettingTitleLabel.Text = "Setting";
            this.SettingTitleLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // AGStartupSettingButton
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.Controls.Add(this.CheckToggleButton);
            this.Controls.Add(this.SettingTitleLabel);
            this.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.Name = "AGStartupSettingButton";
            this.Size = new System.Drawing.Size(330, 30);
            this.ResumeLayout(false);

        }

        #endregion

        private AGLabel SettingTitleLabel;
        private AGToggleImageButton CheckToggleButton;
    }
}
