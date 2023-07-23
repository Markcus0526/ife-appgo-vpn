namespace AppGo.View.CustomControls
{
    partial class AGPhoneNoPrefixButtonControl
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
            this.NumberLabel = new AppGo.View.CustomControls.AGLabel();
            this.DownArrowPictureBox = new CustomControls.AGPictureBox();
            ((System.ComponentModel.ISupportInitialize)(this.DownArrowPictureBox)).BeginInit();
            this.SuspendLayout();
            // 
            // NumberLabel
            // 
            this.NumberLabel.AutoSize = true;
            this.NumberLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.NumberLabel.ForeColor = System.Drawing.Color.Black;
            this.NumberLabel.Location = new System.Drawing.Point(0, 7);
            this.NumberLabel.Margin = new System.Windows.Forms.Padding(0);
            this.NumberLabel.Name = "NumberLabel";
            this.NumberLabel.Size = new System.Drawing.Size(29, 16);
            this.NumberLabel.TabIndex = 0;
            this.NumberLabel.Text = "+86";
            // 
            // DownArrowPictureBox
            // 
            this.DownArrowPictureBox.BackgroundImage = global::AppGo.Properties.Resources.ic_arrow_down;
            this.DownArrowPictureBox.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Zoom;
            this.DownArrowPictureBox.Enabled = false;
            this.DownArrowPictureBox.Location = new System.Drawing.Point(47, 9);
            this.DownArrowPictureBox.Margin = new System.Windows.Forms.Padding(0, 0, 0, 0);
            this.DownArrowPictureBox.Name = "DownArrowPictureBox";
            this.DownArrowPictureBox.Size = new System.Drawing.Size(13, 12);
            this.DownArrowPictureBox.TabIndex = 1;
            this.DownArrowPictureBox.TabStop = false;
            // 
            // AGPhoneNoPrefixButtonControl
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.Transparent;
            this.Controls.Add(this.DownArrowPictureBox);
            this.Controls.Add(this.NumberLabel);
            this.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.Name = "AGPhoneNoPrefixButtonControl";
            this.Size = new System.Drawing.Size(60, 30);
            this.Resize += new System.EventHandler(this.PhoneNoPrefixButtonControl_Resize);
            ((System.ComponentModel.ISupportInitialize)(this.DownArrowPictureBox)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion
        private CustomControls.AGPictureBox DownArrowPictureBox;
        private AGLabel NumberLabel;
    }
}
