namespace AppGo.View
{
    partial class ServiceSelectionViewControl
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
            this.RemoveButton = new AppGo.View.CustomControls.AGImageButton();
            this.OKButton = new AppGo.View.CustomControls.AGImageButton();
            this.ServerListFlowLayoutPanel = new System.Windows.Forms.FlowLayoutPanel();
            this.TitleBarControl = new AppGo.View.CustomControls.AGTitleBarControl();
            this.NoServerLabel = new AppGo.View.CustomControls.AGLabel();
            this.ButtonPanel.SuspendLayout();
            this.SuspendLayout();
            // 
            // ButtonPanel
            // 
            this.ButtonPanel.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(204)))), ((int)(((byte)(204)))), ((int)(((byte)(204)))));
            this.ButtonPanel.Controls.Add(this.RemoveButton);
            this.ButtonPanel.Controls.Add(this.OKButton);
            this.ButtonPanel.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.ButtonPanel.Location = new System.Drawing.Point(0, 527);
            this.ButtonPanel.Margin = new System.Windows.Forms.Padding(0);
            this.ButtonPanel.Name = "ButtonPanel";
            this.ButtonPanel.Size = new System.Drawing.Size(380, 43);
            this.ButtonPanel.TabIndex = 2;
            // 
            // RemoveButton
            // 
            this.RemoveButton.BackgroundImage = global::AppGo.Properties.Resources.ic_remove;
            this.RemoveButton.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Zoom;
            this.RemoveButton.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(204)))), ((int)(((byte)(204)))), ((int)(((byte)(204)))));
            this.RemoveButton.FlatAppearance.BorderSize = 0;
            this.RemoveButton.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(204)))), ((int)(((byte)(204)))), ((int)(((byte)(204)))));
            this.RemoveButton.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(204)))), ((int)(((byte)(204)))), ((int)(((byte)(204)))));
            this.RemoveButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.RemoveButton.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.Default;
            this.RemoveButton.Location = new System.Drawing.Point(20, 9);
            this.RemoveButton.Name = "RemoveButton";
            this.RemoveButton.Size = new System.Drawing.Size(25, 25);
            this.RemoveButton.TabIndex = 1;
            this.RemoveButton.UseVisualStyleBackColor = true;
            this.RemoveButton.Visible = false;
            this.RemoveButton.Click += new System.EventHandler(this.RemoveButton_Click);
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
            this.OKButton.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.Default;
            this.OKButton.Location = new System.Drawing.Point(300, 5);
            this.OKButton.Margin = new System.Windows.Forms.Padding(0);
            this.OKButton.Name = "OKButton";
            this.OKButton.Size = new System.Drawing.Size(75, 34);
            this.OKButton.TabIndex = 0;
            this.OKButton.Text = "OK";
            this.OKButton.UseVisualStyleBackColor = true;
            this.OKButton.Click += new System.EventHandler(this.OKButton_Click);
            // 
            // ServerListFlowLayoutPanel
            // 
            this.ServerListFlowLayoutPanel.AutoScroll = true;
            this.ServerListFlowLayoutPanel.Location = new System.Drawing.Point(20, 68);
            this.ServerListFlowLayoutPanel.Margin = new System.Windows.Forms.Padding(0);
            this.ServerListFlowLayoutPanel.Name = "ServerListFlowLayoutPanel";
            this.ServerListFlowLayoutPanel.Size = new System.Drawing.Size(340, 443);
            this.ServerListFlowLayoutPanel.TabIndex = 4;
            this.ServerListFlowLayoutPanel.Visible = false;
            // 
            // TitleBarControl
            // 
            this.TitleBarControl.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(88)))), ((int)(((byte)(199)))), ((int)(((byte)(255)))));
            this.TitleBarControl.Location = new System.Drawing.Point(0, 0);
            this.TitleBarControl.Margin = new System.Windows.Forms.Padding(0);
            this.TitleBarControl.Name = "TitleBarControl";
            this.TitleBarControl.Size = new System.Drawing.Size(380, 50);
            this.TitleBarControl.TabIndex = 3;
            this.TitleBarControl.Title = "Select server";
            // 
            // NoServerLabel
            // 
            this.NoServerLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.NoServerLabel.Location = new System.Drawing.Point(3, 277);
            this.NoServerLabel.Name = "NoServerLabel";
            this.NoServerLabel.Size = new System.Drawing.Size(372, 53);
            this.NoServerLabel.TabIndex = 5;
            this.NoServerLabel.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // ServiceSelectionViewControl
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.White;
            this.Controls.Add(this.NoServerLabel);
            this.Controls.Add(this.ButtonPanel);
            this.Controls.Add(this.ServerListFlowLayoutPanel);
            this.Controls.Add(this.TitleBarControl);
            this.Name = "ServiceSelectionViewControl";
            this.Size = new System.Drawing.Size(380, 570);
            this.ButtonPanel.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private CustomControls.AGPanel ButtonPanel;
        private CustomControls.AGImageButton OKButton;
        private System.Windows.Forms.FlowLayoutPanel ServerListFlowLayoutPanel;
        private CustomControls.AGTitleBarControl TitleBarControl;
        private CustomControls.AGImageButton RemoveButton;
        private CustomControls.AGLabel NoServerLabel;
    }
}
