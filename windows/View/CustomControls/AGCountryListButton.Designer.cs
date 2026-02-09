namespace AppGo.View.CustomControls
{
    partial class AGCountryListButton
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
            this.CountryFlagPictureBox = new AppGo.View.CustomControls.AGPictureBox();
            this.DownArrowPictureBox = new AppGo.View.CustomControls.AGPictureBox();
            this.CountryNameLabel = new AppGo.View.CustomControls.AGLabel();
            ((System.ComponentModel.ISupportInitialize)(this.CountryFlagPictureBox)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.DownArrowPictureBox)).BeginInit();
            this.SuspendLayout();
            // 
            // CountryFlagPictureBox
            // 
            this.CountryFlagPictureBox.Enabled = false;
            this.CountryFlagPictureBox.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.High;
            this.CountryFlagPictureBox.Location = new System.Drawing.Point(7, 5);
            this.CountryFlagPictureBox.Margin = new System.Windows.Forms.Padding(0);
            this.CountryFlagPictureBox.Name = "CountryFlagPictureBox";
            this.CountryFlagPictureBox.Size = new System.Drawing.Size(20, 20);
            this.CountryFlagPictureBox.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.CountryFlagPictureBox.TabIndex = 0;
            this.CountryFlagPictureBox.TabStop = false;
            this.CountryFlagPictureBox.Click += new System.EventHandler(this.CountryFlagPictureBox_Click);
            // 
            // DownArrowPictureBox
            // 
            this.DownArrowPictureBox.Enabled = false;
            this.DownArrowPictureBox.Image = global::AppGo.Properties.Resources.ic_arrow_down;
            this.DownArrowPictureBox.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.Default;
            this.DownArrowPictureBox.Location = new System.Drawing.Point(167, 7);
            this.DownArrowPictureBox.Margin = new System.Windows.Forms.Padding(3, 4, 3, 4);
            this.DownArrowPictureBox.Name = "DownArrowPictureBox";
            this.DownArrowPictureBox.Size = new System.Drawing.Size(16, 17);
            this.DownArrowPictureBox.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.DownArrowPictureBox.TabIndex = 2;
            this.DownArrowPictureBox.TabStop = false;
            this.DownArrowPictureBox.Click += new System.EventHandler(this.DownArrowPictureBox_Click);
            // 
            // CountryNameLabel
            // 
            this.CountryNameLabel.ForeColor = System.Drawing.Color.White;
            this.CountryNameLabel.Location = new System.Drawing.Point(30, 0);
            this.CountryNameLabel.Margin = new System.Windows.Forms.Padding(0);
            this.CountryNameLabel.Name = "CountryNameLabel";
            this.CountryNameLabel.Size = new System.Drawing.Size(150, 30);
            this.CountryNameLabel.TabIndex = 1;
            this.CountryNameLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // AGCountryListButton
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.Transparent;
            this.BackgroundImage = global::AppGo.Properties.Resources.ic_server_label_background;
            this.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.Controls.Add(this.DownArrowPictureBox);
            this.Controls.Add(this.CountryNameLabel);
            this.Controls.Add(this.CountryFlagPictureBox);
            this.DoubleBuffered = true;
            this.Margin = new System.Windows.Forms.Padding(3, 4, 3, 4);
            this.Name = "AGCountryListButton";
            this.Size = new System.Drawing.Size(187, 30);
            this.Resize += new System.EventHandler(this.ServerListButton_Resize);
            ((System.ComponentModel.ISupportInitialize)(this.CountryFlagPictureBox)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.DownArrowPictureBox)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private CustomControls.AGPictureBox CountryFlagPictureBox;
        private AGLabel CountryNameLabel;
        private CustomControls.AGPictureBox DownArrowPictureBox;
    }
}
