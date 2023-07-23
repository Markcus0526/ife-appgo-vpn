namespace AppGo.View
{
    partial class AboutUsViewControl
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
            this.aboutUsContentLabel = new System.Windows.Forms.TextBox();
            this.CopyrightLabel = new AppGo.View.CustomControls.AGLabel();
            this.AppGoTitleLabel = new AppGo.View.CustomControls.AGLabel();
            this.AboutUsTitleLabel = new AppGo.View.CustomControls.AGLabel();
            this.FollowOnTwitterButton = new AppGo.View.CustomControls.AGImageButton();
            this.BackButton = new AppGo.View.CustomControls.AGImageButton();
            this.appIconPictureBox = new AppGo.View.CustomControls.AGPictureBox();
            ((System.ComponentModel.ISupportInitialize)(this.appIconPictureBox)).BeginInit();
            this.SuspendLayout();
            // 
            // aboutUsContentLabel
            // 
            this.aboutUsContentLabel.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.aboutUsContentLabel.BackColor = System.Drawing.Color.White;
            this.aboutUsContentLabel.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.aboutUsContentLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.aboutUsContentLabel.ForeColor = System.Drawing.Color.DeepSkyBlue;
            this.aboutUsContentLabel.Location = new System.Drawing.Point(15, 238);
            this.aboutUsContentLabel.Multiline = true;
            this.aboutUsContentLabel.Name = "aboutUsContentLabel";
            this.aboutUsContentLabel.ReadOnly = true;
            this.aboutUsContentLabel.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.aboutUsContentLabel.Size = new System.Drawing.Size(362, 243);
            this.aboutUsContentLabel.TabIndex = 24;
            // 
            // CopyrightLabel
            // 
            this.CopyrightLabel.BackColor = System.Drawing.Color.Transparent;
            this.CopyrightLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.CopyrightLabel.ForeColor = System.Drawing.Color.White;
            this.CopyrightLabel.Location = new System.Drawing.Point(0, 125);
            this.CopyrightLabel.Name = "CopyrightLabel";
            this.CopyrightLabel.Size = new System.Drawing.Size(380, 20);
            this.CopyrightLabel.TabIndex = 23;
            this.CopyrightLabel.Text = "copyright©2016-2018AppGo";
            this.CopyrightLabel.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // AppGoTitleLabel
            // 
            this.AppGoTitleLabel.AutoSize = true;
            this.AppGoTitleLabel.BackColor = System.Drawing.Color.Transparent;
            this.AppGoTitleLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 14.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.AppGoTitleLabel.ForeColor = System.Drawing.Color.White;
            this.AppGoTitleLabel.Location = new System.Drawing.Point(129, 91);
            this.AppGoTitleLabel.Name = "AppGoTitleLabel";
            this.AppGoTitleLabel.Size = new System.Drawing.Size(119, 24);
            this.AppGoTitleLabel.TabIndex = 22;
            this.AppGoTitleLabel.Text = "APPGO V1.1";
            // 
            // AboutUsTitleLabel
            // 
            this.AboutUsTitleLabel.BackColor = System.Drawing.Color.Transparent;
            this.AboutUsTitleLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 12.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.AboutUsTitleLabel.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(88)))), ((int)(((byte)(199)))), ((int)(((byte)(255)))));
            this.AboutUsTitleLabel.Location = new System.Drawing.Point(0, 210);
            this.AboutUsTitleLabel.Name = "AboutUsTitleLabel";
            this.AboutUsTitleLabel.Size = new System.Drawing.Size(380, 25);
            this.AboutUsTitleLabel.TabIndex = 21;
            this.AboutUsTitleLabel.Text = "About Us";
            this.AboutUsTitleLabel.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // FollowOnTwitterButton
            // 
            this.FollowOnTwitterButton.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.FollowOnTwitterButton.BackColor = System.Drawing.Color.Transparent;
            this.FollowOnTwitterButton.BackgroundImage = global::AppGo.Properties.Resources.ic_button_background;
            this.FollowOnTwitterButton.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.FollowOnTwitterButton.FlatAppearance.BorderSize = 0;
            this.FollowOnTwitterButton.FlatAppearance.MouseDownBackColor = System.Drawing.Color.White;
            this.FollowOnTwitterButton.FlatAppearance.MouseOverBackColor = System.Drawing.Color.White;
            this.FollowOnTwitterButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.FollowOnTwitterButton.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(136)));
            this.FollowOnTwitterButton.ForeColor = System.Drawing.Color.White;
            this.FollowOnTwitterButton.Location = new System.Drawing.Point(40, 506);
            this.FollowOnTwitterButton.Margin = new System.Windows.Forms.Padding(0);
            this.FollowOnTwitterButton.Name = "FollowOnTwitterButton";
            this.FollowOnTwitterButton.Size = new System.Drawing.Size(300, 36);
            this.FollowOnTwitterButton.TabIndex = 20;
            this.FollowOnTwitterButton.TabStop = false;
            this.FollowOnTwitterButton.Text = "Follow on Twitter";
            this.FollowOnTwitterButton.TextImageRelation = System.Windows.Forms.TextImageRelation.TextAboveImage;
            this.FollowOnTwitterButton.UseVisualStyleBackColor = false;
            this.FollowOnTwitterButton.Click += new System.EventHandler(this.FollowOnTwitterButton_Click);
            // 
            // BackButton
            // 
            this.BackButton.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(88)))), ((int)(((byte)(199)))), ((int)(((byte)(255)))));
            this.BackButton.BackgroundImage = global::AppGo.Properties.Resources.ic_back_white;
            this.BackButton.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Zoom;
            this.BackButton.FlatAppearance.BorderColor = System.Drawing.Color.White;
            this.BackButton.FlatAppearance.BorderSize = 0;
            this.BackButton.FlatAppearance.MouseDownBackColor = System.Drawing.Color.White;
            this.BackButton.FlatAppearance.MouseOverBackColor = System.Drawing.Color.White;
            this.BackButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.BackButton.Location = new System.Drawing.Point(15, 13);
            this.BackButton.Margin = new System.Windows.Forms.Padding(0);
            this.BackButton.Name = "BackButton";
            this.BackButton.Size = new System.Drawing.Size(24, 24);
            this.BackButton.TabIndex = 19;
            this.BackButton.TabStop = false;
            this.BackButton.UseVisualStyleBackColor = false;
            this.BackButton.Click += new System.EventHandler(this.BackButton_Click);
            // 
            // appIconPictureBox
            // 
            this.appIconPictureBox.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.appIconPictureBox.BackColor = System.Drawing.Color.Transparent;
            this.appIconPictureBox.BackgroundImageLayout = System.Windows.Forms.ImageLayout.None;
            this.appIconPictureBox.Enabled = false;
            this.appIconPictureBox.Image = global::AppGo.Properties.Resources.ic_appicon_mark;
            this.appIconPictureBox.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.High;
            this.appIconPictureBox.Location = new System.Drawing.Point(158, 21);
            this.appIconPictureBox.Margin = new System.Windows.Forms.Padding(0);
            this.appIconPictureBox.Name = "appIconPictureBox";
            this.appIconPictureBox.Size = new System.Drawing.Size(60, 60);
            this.appIconPictureBox.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.appIconPictureBox.TabIndex = 4;
            this.appIconPictureBox.TabStop = false;
            // 
            // AboutUsViewControl
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.Transparent;
            this.BackgroundImage = global::AppGo.Properties.Resources.main_back;
            this.Controls.Add(this.aboutUsContentLabel);
            this.Controls.Add(this.CopyrightLabel);
            this.Controls.Add(this.AppGoTitleLabel);
            this.Controls.Add(this.AboutUsTitleLabel);
            this.Controls.Add(this.FollowOnTwitterButton);
            this.Controls.Add(this.BackButton);
            this.Controls.Add(this.appIconPictureBox);
            this.Name = "AboutUsViewControl";
            this.Size = new System.Drawing.Size(380, 570);
            ((System.ComponentModel.ISupportInitialize)(this.appIconPictureBox)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion
        private CustomControls.AGPictureBox appIconPictureBox;
        private View.CustomControls.AGImageButton BackButton;
        private View.CustomControls.AGImageButton FollowOnTwitterButton;
        private View.CustomControls.AGLabel AboutUsTitleLabel;
        private CustomControls.AGLabel AppGoTitleLabel;
        private CustomControls.AGLabel CopyrightLabel;
        private System.Windows.Forms.TextBox aboutUsContentLabel;
    }
}
