namespace AppGo.View.CustomControls
{
    partial class AGPackageListButton
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
            this.DownArrowPictureBox = new AppGo.View.CustomControls.AGPictureBox();
            this.ItemNameLabel = new AppGo.View.CustomControls.AGLabel();
            ((System.ComponentModel.ISupportInitialize)(this.DownArrowPictureBox)).BeginInit();
            this.SuspendLayout();
            // 
            // DownArrowPictureBox
            // 
            this.DownArrowPictureBox.Image = global::AppGo.Properties.Resources.ic_arrow_down;
            this.DownArrowPictureBox.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.High;
            this.DownArrowPictureBox.Location = new System.Drawing.Point(51, 7);
            this.DownArrowPictureBox.Margin = new System.Windows.Forms.Padding(0);
            this.DownArrowPictureBox.Name = "DownArrowPictureBox";
            this.DownArrowPictureBox.Size = new System.Drawing.Size(16, 16);
            this.DownArrowPictureBox.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.DownArrowPictureBox.TabIndex = 2;
            this.DownArrowPictureBox.TabStop = false;
            this.DownArrowPictureBox.Click += new System.EventHandler(this.DownArrowPictureBox_Click);
            // 
            // ItemNameLabel
            // 
            this.ItemNameLabel.ForeColor = System.Drawing.Color.White;
            this.ItemNameLabel.Location = new System.Drawing.Point(7, 0);
            this.ItemNameLabel.Margin = new System.Windows.Forms.Padding(0);
            this.ItemNameLabel.Name = "ItemNameLabel";
            this.ItemNameLabel.Size = new System.Drawing.Size(60, 31);
            this.ItemNameLabel.TabIndex = 1;
            this.ItemNameLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // AGPackageListButton
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 15F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.Transparent;
            this.BackgroundImage = global::AppGo.Properties.Resources.ic_server_label_background;
            this.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.Controls.Add(this.DownArrowPictureBox);
            this.Controls.Add(this.ItemNameLabel);
            this.DoubleBuffered = true;
            this.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.Margin = new System.Windows.Forms.Padding(4);
            this.Name = "AGPackageListButton";
            this.Size = new System.Drawing.Size(69, 31);
            this.Resize += new System.EventHandler(this.ShopItemListButton_Resize);
            ((System.ComponentModel.ISupportInitialize)(this.DownArrowPictureBox)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion
        private AGLabel ItemNameLabel;
        private CustomControls.AGPictureBox DownArrowPictureBox;
    }
}
