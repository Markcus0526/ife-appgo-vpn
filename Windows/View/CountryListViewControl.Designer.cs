namespace AppGo.View
{
    partial class CountryListViewControl
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
            this.ButtonPanel = new AppGo.View.CustomControls.AGPanel();
            this.OKButton = new AppGo.View.CustomControls.AGImageButton();
            this.CountryCodeFlowLayoutPanel = new System.Windows.Forms.FlowLayoutPanel();
            this.TitleBarControl = new AppGo.View.CustomControls.AGTitleBarControl();
            this.ButtonPanel.SuspendLayout();
            this.SuspendLayout();
            // 
            // ButtonPanel
            // 
            this.ButtonPanel.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(204)))), ((int)(((byte)(204)))), ((int)(((byte)(204)))));
            this.ButtonPanel.Controls.Add(this.OKButton);
            this.ButtonPanel.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.ButtonPanel.Location = new System.Drawing.Point(0, 527);
            this.ButtonPanel.Margin = new System.Windows.Forms.Padding(0);
            this.ButtonPanel.Name = "ButtonPanel";
            this.ButtonPanel.Size = new System.Drawing.Size(380, 43);
            this.ButtonPanel.TabIndex = 0;
            // 
            // OKButton
            // 
            this.OKButton.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(204)))), ((int)(((byte)(204)))), ((int)(((byte)(204)))));
            this.OKButton.FlatAppearance.BorderSize = 0;
            this.OKButton.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(204)))), ((int)(((byte)(204)))), ((int)(((byte)(204)))));
            this.OKButton.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(204)))), ((int)(((byte)(204)))), ((int)(((byte)(204)))));
            this.OKButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.OKButton.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.OKButton.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(55)))), ((int)(((byte)(150)))), ((int)(((byte)(198)))));
            this.OKButton.Location = new System.Drawing.Point(301, 6);
            this.OKButton.Margin = new System.Windows.Forms.Padding(0);
            this.OKButton.Name = "OKButton";
            this.OKButton.Size = new System.Drawing.Size(75, 30);
            this.OKButton.TabIndex = 0;
            this.OKButton.Text = "OK";
            this.OKButton.UseVisualStyleBackColor = true;
            this.OKButton.Click += new System.EventHandler(this.OKButton_Click);
            // 
            // CountryCodeFlowLayoutPanel
            // 
            this.CountryCodeFlowLayoutPanel.AutoScroll = true;
            this.CountryCodeFlowLayoutPanel.Location = new System.Drawing.Point(16, 70);
            this.CountryCodeFlowLayoutPanel.Margin = new System.Windows.Forms.Padding(0);
            this.CountryCodeFlowLayoutPanel.Name = "CountryCodeFlowLayoutPanel";
            this.CountryCodeFlowLayoutPanel.Size = new System.Drawing.Size(348, 440);
            this.CountryCodeFlowLayoutPanel.TabIndex = 1;
            // 
            // TitleBarControl
            // 
            this.TitleBarControl.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(88)))), ((int)(((byte)(199)))), ((int)(((byte)(255)))));
            this.TitleBarControl.Location = new System.Drawing.Point(0, 0);
            this.TitleBarControl.Margin = new System.Windows.Forms.Padding(0);
            this.TitleBarControl.Name = "TitleBarControl";
            this.TitleBarControl.Size = new System.Drawing.Size(380, 50);
            this.TitleBarControl.TabIndex = 0;
            this.TitleBarControl.Title = "Country or Region Code";
            // 
            // CountryListViewControl
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.White;
            this.Controls.Add(this.ButtonPanel);
            this.Controls.Add(this.CountryCodeFlowLayoutPanel);
            this.Controls.Add(this.TitleBarControl);
            this.Name = "CountryListViewControl";
            this.Size = new System.Drawing.Size(380, 570);
            this.Load += new System.EventHandler(this.CountryListViewControl_Load);
            this.ButtonPanel.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private CustomControls.AGTitleBarControl TitleBarControl;
        private System.Windows.Forms.FlowLayoutPanel CountryCodeFlowLayoutPanel;
        private CustomControls.AGPanel ButtonPanel;
        private CustomControls.AGImageButton OKButton;
    }
}
