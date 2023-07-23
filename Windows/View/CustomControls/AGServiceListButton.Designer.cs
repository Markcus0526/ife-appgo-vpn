namespace AppGo.View.CustomControls
{
    partial class AGServiceListButton
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
            this.CountryFlagPictureBox.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.Default;
            this.CountryFlagPictureBox.Location = new System.Drawing.Point(7, 5);
            this.CountryFlagPictureBox.Margin = new System.Windows.Forms.Padding(0);
            this.CountryFlagPictureBox.Name = "CountryFlagPictureBox";
            this.CountryFlagPictureBox.Size = new System.Drawing.Size(20, 20);
            this.CountryFlagPictureBox.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.CountryFlagPictureBox.TabIndex = 0;
            this.CountryFlagPictureBox.TabStop = false;
            // 
            // DownArrowPictureBox
            // 
            this.DownArrowPictureBox.Image = global::AppGo.Properties.Resources.ic_arrow_down;
            this.DownArrowPictureBox.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.High;
            this.DownArrowPictureBox.Location = new System.Drawing.Point(165, 7);
            this.DownArrowPictureBox.Name = "DownArrowPictureBox";
            this.DownArrowPictureBox.Size = new System.Drawing.Size(16, 16);
            this.DownArrowPictureBox.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.DownArrowPictureBox.TabIndex = 2;
            this.DownArrowPictureBox.TabStop = false;
            this.DownArrowPictureBox.Visible = false;
            // 
            // CountryNameLabel
            // 
            this.CountryNameLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.CountryNameLabel.ForeColor = System.Drawing.Color.White;
            this.CountryNameLabel.Location = new System.Drawing.Point(30, 0);
            this.CountryNameLabel.Margin = new System.Windows.Forms.Padding(0);
            this.CountryNameLabel.Name = "CountryNameLabel";
            this.CountryNameLabel.Size = new System.Drawing.Size(151, 30);
            this.CountryNameLabel.TabIndex = 1;
            this.CountryNameLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // AGServiceListButton
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
            this.Name = "AGServiceListButton";
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
