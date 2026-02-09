namespace AppGo.View
{
    partial class ShopViewControl
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(ShopViewControl));
            this.AttentionContentLabel = new AppGo.View.CustomControls.AGLabel();
            this.AttentionLabel = new AppGo.View.CustomControls.AGLabel();
            this.TitleBarControl = new AppGo.View.CustomControls.AGTitleBarControl();
            this.PaymentPanel = new AppGo.View.CustomControls.AGPanel();
            this.Pay2Button = new AppGo.View.CustomControls.AGToggleImageButton();
            this.CountryListButton = new AppGo.View.CustomControls.AGCountryListButton();
            this.DataQuoteButton = new AppGo.View.CustomControls.AGPackageListButton();
            this.PriceValueLabel = new AppGo.View.CustomControls.AGLabel();
            this.PeriodValueLabel = new AppGo.View.CustomControls.AGLabel();
            this.FeatureValueLabel = new AppGo.View.CustomControls.AGLabel();
            this.PeriodLabel = new AppGo.View.CustomControls.AGLabel();
            this.Pay3Button = new AppGo.View.CustomControls.AGToggleImageButton();
            this.Pay1Button = new AppGo.View.CustomControls.AGToggleImageButton();
            this.BuyNowButton = new AppGo.View.CustomControls.AGImageButton();
            this.SelectPaymentMethodLabel = new AppGo.View.CustomControls.AGLabel();
            this.PriceLabel = new AppGo.View.CustomControls.AGLabel();
            this.DataQuotaLabel = new AppGo.View.CustomControls.AGLabel();
            this.ServerLabel = new AppGo.View.CustomControls.AGLabel();
            this.FeatureLabel = new AppGo.View.CustomControls.AGLabel();
            this.PaymentPanel.SuspendLayout();
            this.SuspendLayout();
            // 
            // AttentionContentLabel
            // 
            this.AttentionContentLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.AttentionContentLabel.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(55)))), ((int)(((byte)(150)))), ((int)(((byte)(198)))));
            this.AttentionContentLabel.Location = new System.Drawing.Point(88, 470);
            this.AttentionContentLabel.Name = "AttentionContentLabel";
            this.AttentionContentLabel.Size = new System.Drawing.Size(257, 89);
            this.AttentionContentLabel.TabIndex = 2;
            this.AttentionContentLabel.Text = "The data plan will expire whether you reach the network usage limit or pass the d" +
    "ue date.\r\nPlease buy a new plan after expiration.";
            // 
            // AttentionLabel
            // 
            this.AttentionLabel.AutoSize = true;
            this.AttentionLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.AttentionLabel.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(55)))), ((int)(((byte)(150)))), ((int)(((byte)(198)))));
            this.AttentionLabel.Location = new System.Drawing.Point(30, 470);
            this.AttentionLabel.Name = "AttentionLabel";
            this.AttentionLabel.Size = new System.Drawing.Size(57, 15);
            this.AttentionLabel.TabIndex = 0;
            this.AttentionLabel.Text = "Attention:";
            // 
            // TitleBarControl
            // 
            this.TitleBarControl.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.TitleBarControl.AutoSize = true;
            this.TitleBarControl.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(88)))), ((int)(((byte)(199)))), ((int)(((byte)(255)))));
            this.TitleBarControl.Location = new System.Drawing.Point(0, 0);
            this.TitleBarControl.Name = "TitleBarControl";
            this.TitleBarControl.Size = new System.Drawing.Size(383, 50);
            this.TitleBarControl.TabIndex = 0;
            this.TitleBarControl.Title = "Shop";
            // 
            // PaymentPanel
            // 
            this.PaymentPanel.BackgroundImage = global::AppGo.Properties.Resources.ic_border_blue;
            this.PaymentPanel.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.PaymentPanel.Controls.Add(this.Pay2Button);
            this.PaymentPanel.Controls.Add(this.CountryListButton);
            this.PaymentPanel.Controls.Add(this.DataQuoteButton);
            this.PaymentPanel.Controls.Add(this.PriceValueLabel);
            this.PaymentPanel.Controls.Add(this.PeriodValueLabel);
            this.PaymentPanel.Controls.Add(this.FeatureValueLabel);
            this.PaymentPanel.Controls.Add(this.PeriodLabel);
            this.PaymentPanel.Controls.Add(this.Pay3Button);
            this.PaymentPanel.Controls.Add(this.Pay1Button);
            this.PaymentPanel.Controls.Add(this.BuyNowButton);
            this.PaymentPanel.Controls.Add(this.SelectPaymentMethodLabel);
            this.PaymentPanel.Controls.Add(this.PriceLabel);
            this.PaymentPanel.Controls.Add(this.DataQuotaLabel);
            this.PaymentPanel.Controls.Add(this.ServerLabel);
            this.PaymentPanel.Controls.Add(this.FeatureLabel);
            this.PaymentPanel.Location = new System.Drawing.Point(30, 85);
            this.PaymentPanel.Name = "PaymentPanel";
            this.PaymentPanel.Size = new System.Drawing.Size(315, 369);
            this.PaymentPanel.TabIndex = 1;
            this.PaymentPanel.Paint += new System.Windows.Forms.PaintEventHandler(this.PaymentPanel_Paint);
            // 
            // Pay2Button
            // 
            this.Pay2Button.BackgroundImage = global::AppGo.Properties.Resources.ic_alipay_normal;
            this.Pay2Button.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Zoom;
            this.Pay2Button.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.Pay2Button.Location = new System.Drawing.Point(132, 230);
            this.Pay2Button.Name = "Pay2Button";
            this.Pay2Button.NormalImage = global::AppGo.Properties.Resources.ic_alipay_normal;
            this.Pay2Button.Selected = false;
            this.Pay2Button.SelectedImage = global::AppGo.Properties.Resources.ic_alipay_selected;
            this.Pay2Button.Size = new System.Drawing.Size(50, 50);
            this.Pay2Button.TabIndex = 40;
            this.Pay2Button.UseVisualStyleBackColor = true;
            this.Pay2Button.Visible = false;
            this.Pay2Button.Click += new System.EventHandler(this.Pay2Button_Click);
            // 
            // CountryListButton
            // 
            this.CountryListButton.BackColor = System.Drawing.Color.Transparent;
            this.CountryListButton.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("CountryListButton.BackgroundImage")));
            this.CountryListButton.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.CountryListButton.Country = null;
            this.CountryListButton.DownArrowImage = ((System.Drawing.Image)(resources.GetObject("CountryListButton.DownArrowImage")));
            this.CountryListButton.Enabled = false;
            this.CountryListButton.Location = new System.Drawing.Point(97, 53);
            this.CountryListButton.Margin = new System.Windows.Forms.Padding(3, 4, 3, 4);
            this.CountryListButton.Name = "CountryListButton";
            this.CountryListButton.Size = new System.Drawing.Size(201, 30);
            this.CountryListButton.TabIndex = 39;
            this.CountryListButton.TextColor = System.Drawing.Color.White;
            this.CountryListButton.Click += new System.EventHandler(this.CountryListButton_Click);
            // 
            // DataQuoteButton
            // 
            this.DataQuoteButton.BackColor = System.Drawing.Color.Transparent;
            this.DataQuoteButton.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("DataQuoteButton.BackgroundImage")));
            this.DataQuoteButton.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.DataQuoteButton.DownArrowImage = ((System.Drawing.Image)(resources.GetObject("DataQuoteButton.DownArrowImage")));
            this.DataQuoteButton.Enabled = false;
            this.DataQuoteButton.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.DataQuoteButton.Location = new System.Drawing.Point(97, 100);
            this.DataQuoteButton.Margin = new System.Windows.Forms.Padding(4);
            this.DataQuoteButton.Name = "DataQuoteButton";
            this.DataQuoteButton.Size = new System.Drawing.Size(89, 30);
            this.DataQuoteButton.TabIndex = 38;
            this.DataQuoteButton.Title = "";
            this.DataQuoteButton.Click += new System.EventHandler(this.DataQuoteButton_Click);
            // 
            // PriceValueLabel
            // 
            this.PriceValueLabel.AutoSize = true;
            this.PriceValueLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.PriceValueLabel.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(55)))), ((int)(((byte)(150)))), ((int)(((byte)(198)))));
            this.PriceValueLabel.Location = new System.Drawing.Point(98, 148);
            this.PriceValueLabel.Name = "PriceValueLabel";
            this.PriceValueLabel.Size = new System.Drawing.Size(0, 15);
            this.PriceValueLabel.TabIndex = 37;
            // 
            // PeriodValueLabel
            // 
            this.PeriodValueLabel.AutoSize = true;
            this.PeriodValueLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.PeriodValueLabel.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(55)))), ((int)(((byte)(150)))), ((int)(((byte)(198)))));
            this.PeriodValueLabel.Location = new System.Drawing.Point(243, 107);
            this.PeriodValueLabel.Name = "PeriodValueLabel";
            this.PeriodValueLabel.Size = new System.Drawing.Size(0, 15);
            this.PeriodValueLabel.TabIndex = 36;
            // 
            // FeatureValueLabel
            // 
            this.FeatureValueLabel.AutoSize = true;
            this.FeatureValueLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.FeatureValueLabel.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(55)))), ((int)(((byte)(150)))), ((int)(((byte)(198)))));
            this.FeatureValueLabel.Location = new System.Drawing.Point(97, 20);
            this.FeatureValueLabel.Name = "FeatureValueLabel";
            this.FeatureValueLabel.Size = new System.Drawing.Size(0, 15);
            this.FeatureValueLabel.TabIndex = 35;
            // 
            // PeriodLabel
            // 
            this.PeriodLabel.AutoSize = true;
            this.PeriodLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.PeriodLabel.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(55)))), ((int)(((byte)(150)))), ((int)(((byte)(198)))));
            this.PeriodLabel.Location = new System.Drawing.Point(194, 107);
            this.PeriodLabel.Name = "PeriodLabel";
            this.PeriodLabel.Size = new System.Drawing.Size(43, 15);
            this.PeriodLabel.TabIndex = 32;
            this.PeriodLabel.Text = "Period";
            // 
            // Pay3Button
            // 
            this.Pay3Button.BackgroundImage = global::AppGo.Properties.Resources.ic_acoin_normal;
            this.Pay3Button.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Zoom;
            this.Pay3Button.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.Pay3Button.Location = new System.Drawing.Point(209, 231);
            this.Pay3Button.Name = "Pay3Button";
            this.Pay3Button.NormalImage = global::AppGo.Properties.Resources.ic_acoin_normal;
            this.Pay3Button.Selected = false;
            this.Pay3Button.SelectedImage = global::AppGo.Properties.Resources.ic_acoin_selected;
            this.Pay3Button.Size = new System.Drawing.Size(50, 50);
            this.Pay3Button.TabIndex = 9;
            this.Pay3Button.UseVisualStyleBackColor = true;
            this.Pay3Button.Visible = false;
            this.Pay3Button.Click += new System.EventHandler(this.Pay3Button_Click);
            // 
            // Pay1Button
            // 
            this.Pay1Button.BackgroundImage = global::AppGo.Properties.Resources.ic_alipay_normal;
            this.Pay1Button.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Zoom;
            this.Pay1Button.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.Pay1Button.Location = new System.Drawing.Point(55, 231);
            this.Pay1Button.Name = "Pay1Button";
            this.Pay1Button.NormalImage = global::AppGo.Properties.Resources.ic_alipay_normal;
            this.Pay1Button.Selected = false;
            this.Pay1Button.SelectedImage = global::AppGo.Properties.Resources.ic_alipay_selected;
            this.Pay1Button.Size = new System.Drawing.Size(50, 50);
            this.Pay1Button.TabIndex = 7;
            this.Pay1Button.UseVisualStyleBackColor = true;
            this.Pay1Button.Visible = false;
            this.Pay1Button.Click += new System.EventHandler(this.Pay1Button_Click);
            // 
            // BuyNowButton
            // 
            this.BuyNowButton.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.BuyNowButton.BackColor = System.Drawing.Color.Transparent;
            this.BuyNowButton.BackgroundImage = global::AppGo.Properties.Resources.ic_button_background;
            this.BuyNowButton.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.BuyNowButton.FlatAppearance.BorderSize = 0;
            this.BuyNowButton.FlatAppearance.MouseDownBackColor = System.Drawing.Color.White;
            this.BuyNowButton.FlatAppearance.MouseOverBackColor = System.Drawing.Color.White;
            this.BuyNowButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.BuyNowButton.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(136)));
            this.BuyNowButton.ForeColor = System.Drawing.Color.White;
            this.BuyNowButton.Location = new System.Drawing.Point(45, 316);
            this.BuyNowButton.Margin = new System.Windows.Forms.Padding(0);
            this.BuyNowButton.Name = "BuyNowButton";
            this.BuyNowButton.Size = new System.Drawing.Size(225, 36);
            this.BuyNowButton.TabIndex = 6;
            this.BuyNowButton.TabStop = false;
            this.BuyNowButton.Text = "Buy Now";
            this.BuyNowButton.TextImageRelation = System.Windows.Forms.TextImageRelation.TextAboveImage;
            this.BuyNowButton.UseVisualStyleBackColor = false;
            this.BuyNowButton.Visible = false;
            this.BuyNowButton.Click += new System.EventHandler(this.BuyNowButton_Click);
            // 
            // SelectPaymentMethodLabel
            // 
            this.SelectPaymentMethodLabel.AutoSize = true;
            this.SelectPaymentMethodLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.SelectPaymentMethodLabel.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(55)))), ((int)(((byte)(150)))), ((int)(((byte)(198)))));
            this.SelectPaymentMethodLabel.Location = new System.Drawing.Point(20, 191);
            this.SelectPaymentMethodLabel.Name = "SelectPaymentMethodLabel";
            this.SelectPaymentMethodLabel.Size = new System.Drawing.Size(136, 15);
            this.SelectPaymentMethodLabel.TabIndex = 5;
            this.SelectPaymentMethodLabel.Text = "Select payment method";
            // 
            // PriceLabel
            // 
            this.PriceLabel.AutoSize = true;
            this.PriceLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.PriceLabel.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(55)))), ((int)(((byte)(150)))), ((int)(((byte)(198)))));
            this.PriceLabel.Location = new System.Drawing.Point(20, 149);
            this.PriceLabel.Name = "PriceLabel";
            this.PriceLabel.Size = new System.Drawing.Size(35, 15);
            this.PriceLabel.TabIndex = 4;
            this.PriceLabel.Text = "Price";
            // 
            // DataQuotaLabel
            // 
            this.DataQuotaLabel.AutoSize = true;
            this.DataQuotaLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.DataQuotaLabel.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(55)))), ((int)(((byte)(150)))), ((int)(((byte)(198)))));
            this.DataQuotaLabel.Location = new System.Drawing.Point(20, 104);
            this.DataQuotaLabel.Name = "DataQuotaLabel";
            this.DataQuotaLabel.Size = new System.Drawing.Size(67, 15);
            this.DataQuotaLabel.TabIndex = 3;
            this.DataQuotaLabel.Text = "Data quota";
            // 
            // ServerLabel
            // 
            this.ServerLabel.AutoSize = true;
            this.ServerLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.ServerLabel.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(55)))), ((int)(((byte)(150)))), ((int)(((byte)(198)))));
            this.ServerLabel.Location = new System.Drawing.Point(20, 61);
            this.ServerLabel.Name = "ServerLabel";
            this.ServerLabel.Size = new System.Drawing.Size(42, 15);
            this.ServerLabel.TabIndex = 2;
            this.ServerLabel.Text = "Server";
            // 
            // FeatureLabel
            // 
            this.FeatureLabel.AutoSize = true;
            this.FeatureLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.FeatureLabel.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(55)))), ((int)(((byte)(150)))), ((int)(((byte)(198)))));
            this.FeatureLabel.Location = new System.Drawing.Point(20, 20);
            this.FeatureLabel.Name = "FeatureLabel";
            this.FeatureLabel.Size = new System.Drawing.Size(49, 15);
            this.FeatureLabel.TabIndex = 1;
            this.FeatureLabel.Text = "Feature";
            // 
            // ShopViewControl
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.White;
            this.Controls.Add(this.AttentionContentLabel);
            this.Controls.Add(this.AttentionLabel);
            this.Controls.Add(this.TitleBarControl);
            this.Controls.Add(this.PaymentPanel);
            this.Name = "ShopViewControl";
            this.Size = new System.Drawing.Size(380, 570);
            this.PaymentPanel.ResumeLayout(false);
            this.PaymentPanel.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private CustomControls.AGTitleBarControl TitleBarControl;
        private CustomControls.AGLabel AttentionLabel;
        private CustomControls.AGLabel AttentionContentLabel;
        private CustomControls.AGLabel SelectPaymentMethodLabel;
        private CustomControls.AGLabel PriceLabel;
        private CustomControls.AGLabel DataQuotaLabel;
        private CustomControls.AGLabel ServerLabel;
        private CustomControls.AGLabel FeatureLabel;
        private CustomControls.AGImageButton BuyNowButton;
        private CustomControls.AGToggleImageButton Pay1Button;
        private CustomControls.AGToggleImageButton Pay3Button;
        private CustomControls.AGLabel PeriodLabel;
        private CustomControls.AGPanel PaymentPanel;        
        private CustomControls.AGLabel FeatureValueLabel;
        private CustomControls.AGLabel PeriodValueLabel;
        private CustomControls.AGLabel PriceValueLabel;
        private CustomControls.AGPackageListButton DataQuoteButton;
        private CustomControls.AGCountryListButton CountryListButton;
        private CustomControls.AGToggleImageButton Pay2Button;
    }
}
