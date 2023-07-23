namespace AppGo.View.CustomControls
{
    partial class AGServiceListItem
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
            this.ServerNameLabel = new AppGo.View.CustomControls.AGLabel();
            this.SelectionStateIndicatorPictureBox = new CustomControls.AGPictureBox();
            this.PingTimeLabel = new AppGo.View.CustomControls.AGLabel();
            ((System.ComponentModel.ISupportInitialize)(this.SelectionStateIndicatorPictureBox)).BeginInit();
            this.SuspendLayout();
            // 
            // ServerNameLabel
            // 
            this.ServerNameLabel.AutoSize = true;
            this.ServerNameLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.ServerNameLabel.ForeColor = System.Drawing.Color.White;
            this.ServerNameLabel.Location = new System.Drawing.Point(70, 13);
            this.ServerNameLabel.Name = "ServerNameLabel";
            this.ServerNameLabel.Size = new System.Drawing.Size(45, 18);
            this.ServerNameLabel.TabIndex = 1;
            this.ServerNameLabel.Text = "Brazil";
            // 
            // SelectionStateIndicatorPictureBox
            // 
            this.SelectionStateIndicatorPictureBox.Enabled = false;
            this.SelectionStateIndicatorPictureBox.Image = global::AppGo.Properties.Resources.ic_checked;
            this.SelectionStateIndicatorPictureBox.Location = new System.Drawing.Point(290, 20);
            this.SelectionStateIndicatorPictureBox.Name = "SelectionStateIndicatorPictureBox";
            this.SelectionStateIndicatorPictureBox.Size = new System.Drawing.Size(10, 10);
            this.SelectionStateIndicatorPictureBox.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.SelectionStateIndicatorPictureBox.TabIndex = 2;
            this.SelectionStateIndicatorPictureBox.TabStop = false;
            // 
            // PingTimeLabel
            // 
            this.PingTimeLabel.AutoSize = true;
            this.PingTimeLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.PingTimeLabel.ForeColor = System.Drawing.Color.White;
            this.PingTimeLabel.Location = new System.Drawing.Point(243, 20);
            this.PingTimeLabel.Name = "PingTimeLabel";
            this.PingTimeLabel.Size = new System.Drawing.Size(41, 18);
            this.PingTimeLabel.TabIndex = 3;
            this.PingTimeLabel.Text = "+860";
            // 
            // ServrListItem
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(88)))), ((int)(((byte)(199)))), ((int)(((byte)(255)))));
            this.Controls.Add(this.PingTimeLabel);
            this.Controls.Add(this.SelectionStateIndicatorPictureBox);
            this.Controls.Add(this.ServerNameLabel);
            this.Margin = new System.Windows.Forms.Padding(0);
            this.Name = "ServrListItem";
            this.Size = new System.Drawing.Size(310, 50);
            this.Resize += new System.EventHandler(this.ServerListItem_Resize);
            ((System.ComponentModel.ISupportInitialize)(this.SelectionStateIndicatorPictureBox)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion
        private AGLabel ServerNameLabel;
        private CustomControls.AGPictureBox SelectionStateIndicatorPictureBox;
        private AGLabel PingTimeLabel;
    }
}
