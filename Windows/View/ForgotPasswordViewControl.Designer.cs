namespace AppGo.View
{
    partial class ForgotPasswordViewControl
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
            this.BackButton = new AppGo.View.CustomControls.AGImageButton();
            this.InputGroupPanel = new AppGo.View.CustomControls.AGPanel();
            this.PhoneNumberTextBox = new AppGo.View.CustomControls.AGPlaceholderTextBox();
            this.VerificationCodeButton = new AppGo.View.CustomControls.AGImageButton();
            this.VerificationCodeTextBox = new AppGo.View.CustomControls.AGPlaceholderTextBox();
            this.PhoneNoPrefixButton = new AppGo.View.CustomControls.AGPhoneNoPrefixButtonControl();
            this.NewPasswordTextBox = new AppGo.View.CustomControls.AGPlaceholderTextBox();
            this.ConfirmPasswordTextBox = new AppGo.View.CustomControls.AGPlaceholderTextBox();
            this.pictureBox3 = new AppGo.View.CustomControls.AGPictureBox();
            this.pictureBox2 = new AppGo.View.CustomControls.AGPictureBox();
            this.pictureBox1 = new AppGo.View.CustomControls.AGPictureBox();
            this.ConfirmPasswordLabel = new AppGo.View.CustomControls.AGLabel();
            this.NewPasswordLabel = new AppGo.View.CustomControls.AGLabel();
            this.VerificationCodeLabel = new AppGo.View.CustomControls.AGLabel();
            this.PhoneNumberLabel = new AppGo.View.CustomControls.AGLabel();
            this.ResetPasswordButton = new AppGo.View.CustomControls.AGImageButton();
            this.AppTitlePictureBox = new AppGo.View.CustomControls.AGPictureBox();
            this.AppIconPictureBox = new AppGo.View.CustomControls.AGPictureBox();
            this.InputGroupPanel.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox3)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox2)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.AppTitlePictureBox)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.AppIconPictureBox)).BeginInit();
            this.SuspendLayout();
            // 
            // BackButton
            // 
            this.BackButton.BackColor = System.Drawing.Color.White;
            this.BackButton.BackgroundImage = global::AppGo.Properties.Resources.ic_back_blue;
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
            this.BackButton.TabIndex = 18;
            this.BackButton.TabStop = false;
            this.BackButton.UseVisualStyleBackColor = false;
            this.BackButton.Click += new System.EventHandler(this.BackButton_Click);
            // 
            // InputGroupPanel
            // 
            this.InputGroupPanel.BackgroundImage = global::AppGo.Properties.Resources.ic_border_blue;
            this.InputGroupPanel.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.InputGroupPanel.Controls.Add(this.PhoneNumberTextBox);
            this.InputGroupPanel.Controls.Add(this.VerificationCodeButton);
            this.InputGroupPanel.Controls.Add(this.VerificationCodeTextBox);
            this.InputGroupPanel.Controls.Add(this.PhoneNoPrefixButton);
            this.InputGroupPanel.Controls.Add(this.NewPasswordTextBox);
            this.InputGroupPanel.Controls.Add(this.ConfirmPasswordTextBox);
            this.InputGroupPanel.Controls.Add(this.pictureBox3);
            this.InputGroupPanel.Controls.Add(this.pictureBox2);
            this.InputGroupPanel.Controls.Add(this.pictureBox1);
            this.InputGroupPanel.Controls.Add(this.ConfirmPasswordLabel);
            this.InputGroupPanel.Controls.Add(this.NewPasswordLabel);
            this.InputGroupPanel.Controls.Add(this.VerificationCodeLabel);
            this.InputGroupPanel.Controls.Add(this.PhoneNumberLabel);
            this.InputGroupPanel.Location = new System.Drawing.Point(30, 170);
            this.InputGroupPanel.Name = "InputGroupPanel";
            this.InputGroupPanel.Size = new System.Drawing.Size(320, 205);
            this.InputGroupPanel.TabIndex = 7;
            // 
            // PhoneNumberTextBox
            // 
            this.PhoneNumberTextBox.BackColor = System.Drawing.Color.White;
            this.PhoneNumberTextBox.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.PhoneNumberTextBox.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.PhoneNumberTextBox.ForeColor = System.Drawing.Color.Black;
            this.PhoneNumberTextBox.Location = new System.Drawing.Point(174, 25);
            this.PhoneNumberTextBox.Name = "PhoneNumberTextBox";
            this.PhoneNumberTextBox.Size = new System.Drawing.Size(122, 15);
            this.PhoneNumberTextBox.TabIndex = 1;
            // 
            // VerificationCodeButton
            // 
            this.VerificationCodeButton.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.VerificationCodeButton.BackColor = System.Drawing.Color.Transparent;
            this.VerificationCodeButton.BackgroundImage = global::AppGo.Properties.Resources.ic_button_background_small;
            this.VerificationCodeButton.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.VerificationCodeButton.FlatAppearance.BorderSize = 0;
            this.VerificationCodeButton.FlatAppearance.MouseDownBackColor = System.Drawing.Color.White;
            this.VerificationCodeButton.FlatAppearance.MouseOverBackColor = System.Drawing.Color.White;
            this.VerificationCodeButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.VerificationCodeButton.Font = new System.Drawing.Font("Microsoft Sans Serif", 6.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.VerificationCodeButton.ForeColor = System.Drawing.Color.White;
            this.VerificationCodeButton.Location = new System.Drawing.Point(214, 66);
            this.VerificationCodeButton.Margin = new System.Windows.Forms.Padding(0);
            this.VerificationCodeButton.Name = "VerificationCodeButton";
            this.VerificationCodeButton.Size = new System.Drawing.Size(90, 26);
            this.VerificationCodeButton.TabIndex = 8;
            this.VerificationCodeButton.TabStop = false;
            this.VerificationCodeButton.Text = "Code";
            this.VerificationCodeButton.TextImageRelation = System.Windows.Forms.TextImageRelation.TextAboveImage;
            this.VerificationCodeButton.UseVisualStyleBackColor = true;
            this.VerificationCodeButton.Click += new System.EventHandler(this.VerificationCodeButton_Click);
            // 
            // VerificationCodeTextBox
            // 
            this.VerificationCodeTextBox.BackColor = System.Drawing.Color.White;
            this.VerificationCodeTextBox.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.VerificationCodeTextBox.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.VerificationCodeTextBox.ForeColor = System.Drawing.Color.Black;
            this.VerificationCodeTextBox.Location = new System.Drawing.Point(134, 71);
            this.VerificationCodeTextBox.Name = "VerificationCodeTextBox";
            this.VerificationCodeTextBox.Size = new System.Drawing.Size(76, 15);
            this.VerificationCodeTextBox.TabIndex = 2;
            // 
            // PhoneNoPrefixButton
            // 
            this.PhoneNoPrefixButton.BackColor = System.Drawing.Color.Transparent;
            this.PhoneNoPrefixButton.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.PhoneNoPrefixButton.Location = new System.Drawing.Point(119, 20);
            this.PhoneNoPrefixButton.Margin = new System.Windows.Forms.Padding(4);
            this.PhoneNoPrefixButton.Name = "PhoneNoPrefixButton";
            this.PhoneNoPrefixButton.Size = new System.Drawing.Size(50, 26);
            this.PhoneNoPrefixButton.TabIndex = 20;
            this.PhoneNoPrefixButton.TabStop = false;
            this.PhoneNoPrefixButton.Click += new System.EventHandler(this.PhoneNoPrefixButton_Click);
            // 
            // NewPasswordTextBox
            // 
            this.NewPasswordTextBox.BackColor = System.Drawing.Color.White;
            this.NewPasswordTextBox.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.NewPasswordTextBox.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.NewPasswordTextBox.ForeColor = System.Drawing.Color.Black;
            this.NewPasswordTextBox.Location = new System.Drawing.Point(134, 117);
            this.NewPasswordTextBox.Name = "NewPasswordTextBox";
            this.NewPasswordTextBox.Size = new System.Drawing.Size(160, 15);
            this.NewPasswordTextBox.TabIndex = 3;
            // 
            // ConfirmPasswordTextBox
            // 
            this.ConfirmPasswordTextBox.BackColor = System.Drawing.Color.White;
            this.ConfirmPasswordTextBox.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.ConfirmPasswordTextBox.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.ConfirmPasswordTextBox.ForeColor = System.Drawing.Color.Black;
            this.ConfirmPasswordTextBox.Location = new System.Drawing.Point(134, 163);
            this.ConfirmPasswordTextBox.Name = "ConfirmPasswordTextBox";
            this.ConfirmPasswordTextBox.Size = new System.Drawing.Size(160, 15);
            this.ConfirmPasswordTextBox.TabIndex = 4;
            // 
            // pictureBox3
            // 
            this.pictureBox3.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(182)))), ((int)(((byte)(241)))), ((int)(((byte)(255)))));
            this.pictureBox3.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.High;
            this.pictureBox3.Location = new System.Drawing.Point(130, 149);
            this.pictureBox3.Margin = new System.Windows.Forms.Padding(0);
            this.pictureBox3.Name = "pictureBox3";
            this.pictureBox3.Size = new System.Drawing.Size(165, 1);
            this.pictureBox3.TabIndex = 6;
            this.pictureBox3.TabStop = false;
            // 
            // pictureBox2
            // 
            this.pictureBox2.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(182)))), ((int)(((byte)(241)))), ((int)(((byte)(255)))));
            this.pictureBox2.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.High;
            this.pictureBox2.Location = new System.Drawing.Point(130, 101);
            this.pictureBox2.Margin = new System.Windows.Forms.Padding(0);
            this.pictureBox2.Name = "pictureBox2";
            this.pictureBox2.Size = new System.Drawing.Size(165, 1);
            this.pictureBox2.TabIndex = 5;
            this.pictureBox2.TabStop = false;
            // 
            // pictureBox1
            // 
            this.pictureBox1.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(182)))), ((int)(((byte)(241)))), ((int)(((byte)(255)))));
            this.pictureBox1.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.High;
            this.pictureBox1.Location = new System.Drawing.Point(130, 54);
            this.pictureBox1.Margin = new System.Windows.Forms.Padding(0);
            this.pictureBox1.Name = "pictureBox1";
            this.pictureBox1.Size = new System.Drawing.Size(165, 1);
            this.pictureBox1.TabIndex = 4;
            this.pictureBox1.TabStop = false;
            // 
            // ConfirmPasswordLabel
            // 
            this.ConfirmPasswordLabel.AutoSize = true;
            this.ConfirmPasswordLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.ConfirmPasswordLabel.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(88)))), ((int)(((byte)(199)))), ((int)(((byte)(255)))));
            this.ConfirmPasswordLabel.Location = new System.Drawing.Point(12, 163);
            this.ConfirmPasswordLabel.Name = "ConfirmPasswordLabel";
            this.ConfirmPasswordLabel.Size = new System.Drawing.Size(116, 16);
            this.ConfirmPasswordLabel.TabIndex = 3;
            this.ConfirmPasswordLabel.Text = "Confirm Password";
            // 
            // NewPasswordLabel
            // 
            this.NewPasswordLabel.AutoSize = true;
            this.NewPasswordLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.NewPasswordLabel.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(88)))), ((int)(((byte)(199)))), ((int)(((byte)(255)))));
            this.NewPasswordLabel.Location = new System.Drawing.Point(12, 117);
            this.NewPasswordLabel.Name = "NewPasswordLabel";
            this.NewPasswordLabel.Size = new System.Drawing.Size(98, 16);
            this.NewPasswordLabel.TabIndex = 2;
            this.NewPasswordLabel.Text = "New Password";
            // 
            // VerificationCodeLabel
            // 
            this.VerificationCodeLabel.AutoSize = true;
            this.VerificationCodeLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.VerificationCodeLabel.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(88)))), ((int)(((byte)(199)))), ((int)(((byte)(255)))));
            this.VerificationCodeLabel.Location = new System.Drawing.Point(12, 71);
            this.VerificationCodeLabel.Name = "VerificationCodeLabel";
            this.VerificationCodeLabel.Size = new System.Drawing.Size(41, 16);
            this.VerificationCodeLabel.TabIndex = 1;
            this.VerificationCodeLabel.Text = "Code";
            // 
            // PhoneNumberLabel
            // 
            this.PhoneNumberLabel.AutoSize = true;
            this.PhoneNumberLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.PhoneNumberLabel.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(88)))), ((int)(((byte)(199)))), ((int)(((byte)(255)))));
            this.PhoneNumberLabel.Location = new System.Drawing.Point(12, 25);
            this.PhoneNumberLabel.Name = "PhoneNumberLabel";
            this.PhoneNumberLabel.Size = new System.Drawing.Size(98, 16);
            this.PhoneNumberLabel.TabIndex = 0;
            this.PhoneNumberLabel.Text = "Phone Number";
            // 
            // ResetPasswordButton
            // 
            this.ResetPasswordButton.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.ResetPasswordButton.BackColor = System.Drawing.Color.Transparent;
            this.ResetPasswordButton.BackgroundImage = global::AppGo.Properties.Resources.ic_button_background;
            this.ResetPasswordButton.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.ResetPasswordButton.FlatAppearance.BorderSize = 0;
            this.ResetPasswordButton.FlatAppearance.MouseDownBackColor = System.Drawing.Color.White;
            this.ResetPasswordButton.FlatAppearance.MouseOverBackColor = System.Drawing.Color.White;
            this.ResetPasswordButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.ResetPasswordButton.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(136)));
            this.ResetPasswordButton.ForeColor = System.Drawing.Color.White;
            this.ResetPasswordButton.Location = new System.Drawing.Point(40, 458);
            this.ResetPasswordButton.Margin = new System.Windows.Forms.Padding(0);
            this.ResetPasswordButton.Name = "ResetPasswordButton";
            this.ResetPasswordButton.Size = new System.Drawing.Size(300, 36);
            this.ResetPasswordButton.TabIndex = 6;
            this.ResetPasswordButton.TabStop = false;
            this.ResetPasswordButton.Text = "Reset Password";
            this.ResetPasswordButton.TextImageRelation = System.Windows.Forms.TextImageRelation.TextAboveImage;
            this.ResetPasswordButton.UseVisualStyleBackColor = true;
            this.ResetPasswordButton.Click += new System.EventHandler(this.ResetPasswordButton_Click);
            // 
            // AppTitlePictureBox
            // 
            this.AppTitlePictureBox.BackColor = System.Drawing.Color.White;
            this.AppTitlePictureBox.Enabled = false;
            this.AppTitlePictureBox.Image = global::AppGo.Properties.Resources.ic_appgo_title_blue;
            this.AppTitlePictureBox.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.High;
            this.AppTitlePictureBox.Location = new System.Drawing.Point(140, 96);
            this.AppTitlePictureBox.Margin = new System.Windows.Forms.Padding(0);
            this.AppTitlePictureBox.Name = "AppTitlePictureBox";
            this.AppTitlePictureBox.Size = new System.Drawing.Size(100, 30);
            this.AppTitlePictureBox.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.AppTitlePictureBox.TabIndex = 4;
            this.AppTitlePictureBox.TabStop = false;
            // 
            // AppIconPictureBox
            // 
            this.AppIconPictureBox.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.AppIconPictureBox.BackColor = System.Drawing.Color.White;
            this.AppIconPictureBox.BackgroundImageLayout = System.Windows.Forms.ImageLayout.None;
            this.AppIconPictureBox.Enabled = false;
            this.AppIconPictureBox.Image = global::AppGo.Properties.Resources.ic_appicon_mark;
            this.AppIconPictureBox.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.High;
            this.AppIconPictureBox.Location = new System.Drawing.Point(160, 25);
            this.AppIconPictureBox.Margin = new System.Windows.Forms.Padding(0);
            this.AppIconPictureBox.Name = "AppIconPictureBox";
            this.AppIconPictureBox.Size = new System.Drawing.Size(60, 60);
            this.AppIconPictureBox.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.AppIconPictureBox.TabIndex = 3;
            this.AppIconPictureBox.TabStop = false;
            // 
            // ForgotPasswordViewControl
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.White;
            this.Controls.Add(this.BackButton);
            this.Controls.Add(this.InputGroupPanel);
            this.Controls.Add(this.ResetPasswordButton);
            this.Controls.Add(this.AppTitlePictureBox);
            this.Controls.Add(this.AppIconPictureBox);
            this.Name = "ForgotPasswordViewControl";
            this.Size = new System.Drawing.Size(380, 570);
            this.Load += new System.EventHandler(this.ForgotPasswordViewControl_Load);
            this.InputGroupPanel.ResumeLayout(false);
            this.InputGroupPanel.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox3)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox2)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.AppTitlePictureBox)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.AppIconPictureBox)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private CustomControls.AGPictureBox AppTitlePictureBox;
        private CustomControls.AGPictureBox AppIconPictureBox;
        private CustomControls.AGPictureBox pictureBox1;
        private CustomControls.AGPictureBox pictureBox3;
        private CustomControls.AGPictureBox pictureBox2;
        private CustomControls.AGPlaceholderTextBox NewPasswordTextBox;
        private CustomControls.AGPlaceholderTextBox ConfirmPasswordTextBox;
        private CustomControls.AGPlaceholderTextBox VerificationCodeTextBox;
        private CustomControls.AGPhoneNoPrefixButtonControl PhoneNoPrefixButton;
        private CustomControls.AGPlaceholderTextBox PhoneNumberTextBox;
        private CustomControls.AGImageButton ResetPasswordButton;
        private CustomControls.AGPanel InputGroupPanel;
        private CustomControls.AGLabel ConfirmPasswordLabel;
        private CustomControls.AGLabel NewPasswordLabel;
        private CustomControls.AGLabel VerificationCodeLabel;
        private CustomControls.AGLabel PhoneNumberLabel;
        private CustomControls.AGImageButton VerificationCodeButton;
        private CustomControls.AGImageButton BackButton;
    }
}
