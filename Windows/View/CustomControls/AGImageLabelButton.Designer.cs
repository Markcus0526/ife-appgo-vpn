namespace AppGo.View.CustomControls
{
    partial class AGImageLabelButton
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
            this.ButtonImagePictureBox = new AppGo.View.CustomControls.AGPictureBox();
            this.ButtonTitleLabel = new AppGo.View.CustomControls.AGLabel();
            ((System.ComponentModel.ISupportInitialize)(this.ButtonImagePictureBox)).BeginInit();
            this.SuspendLayout();
            // 
            // ButtonImagePictureBox
            // 
            this.ButtonImagePictureBox.BackgroundImage = global::AppGo.Properties.Resources.ic_mail;
            this.ButtonImagePictureBox.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Zoom;
            this.ButtonImagePictureBox.Enabled = false;
            this.ButtonImagePictureBox.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.High;
            this.ButtonImagePictureBox.Location = new System.Drawing.Point(0, 0);
            this.ButtonImagePictureBox.Margin = new System.Windows.Forms.Padding(0);
            this.ButtonImagePictureBox.Name = "ButtonImagePictureBox";
            this.ButtonImagePictureBox.Size = new System.Drawing.Size(32, 32);
            this.ButtonImagePictureBox.TabIndex = 0;
            this.ButtonImagePictureBox.TabStop = false;
            // 
            // ButtonTitleLabel
            // 
            this.ButtonTitleLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.ButtonTitleLabel.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(55)))), ((int)(((byte)(150)))), ((int)(((byte)(198)))));
            this.ButtonTitleLabel.Location = new System.Drawing.Point(38, 0);
            this.ButtonTitleLabel.Name = "ButtonTitleLabel";
            this.ButtonTitleLabel.Size = new System.Drawing.Size(139, 32);
            this.ButtonTitleLabel.TabIndex = 1;
            this.ButtonTitleLabel.Text = "Button Name";
            this.ButtonTitleLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // AGImageLabelButton
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.Transparent;
            this.Controls.Add(this.ButtonTitleLabel);
            this.Controls.Add(this.ButtonImagePictureBox);
            this.Margin = new System.Windows.Forms.Padding(0);
            this.Name = "AGImageLabelButton";
            this.Size = new System.Drawing.Size(180, 32);
            this.Resize += new System.EventHandler(this.AGImageLabelButton_Resize);
            ((System.ComponentModel.ISupportInitialize)(this.ButtonImagePictureBox)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private CustomControls.AGPictureBox ButtonImagePictureBox;
        private AGLabel ButtonTitleLabel;
    }
}
