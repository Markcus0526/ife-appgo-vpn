namespace AppGo.View.CustomControls
{
    partial class AGLanguageListButton
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
            this.LanguageLabel = new AppGo.View.CustomControls.AGLabel();
            this.LanguageValueLabel = new AppGo.View.CustomControls.AGLabel();
            this.DownArrowPictureBox = new AppGo.View.CustomControls.AGPictureBox();
            ((System.ComponentModel.ISupportInitialize)(this.DownArrowPictureBox)).BeginInit();
            this.SuspendLayout();
            // 
            // LanguageLabel
            // 
            this.LanguageLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.LanguageLabel.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(55)))), ((int)(((byte)(150)))), ((int)(((byte)(198)))));
            this.LanguageLabel.Location = new System.Drawing.Point(20, 0);
            this.LanguageLabel.Margin = new System.Windows.Forms.Padding(0);
            this.LanguageLabel.Name = "LanguageLabel";
            this.LanguageLabel.Size = new System.Drawing.Size(149, 30);
            this.LanguageLabel.TabIndex = 0;
            this.LanguageLabel.Text = "Language";
            this.LanguageLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // LanguageValueLabel
            // 
            this.LanguageValueLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.LanguageValueLabel.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(55)))), ((int)(((byte)(150)))), ((int)(((byte)(198)))));
            this.LanguageValueLabel.Location = new System.Drawing.Point(193, 0);
            this.LanguageValueLabel.Margin = new System.Windows.Forms.Padding(0);
            this.LanguageValueLabel.Name = "LanguageValueLabel";
            this.LanguageValueLabel.Size = new System.Drawing.Size(100, 30);
            this.LanguageValueLabel.TabIndex = 1;
            this.LanguageValueLabel.Text = "English";
            this.LanguageValueLabel.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // DownArrowPictureBox
            // 
            this.DownArrowPictureBox.Image = global::AppGo.Properties.Resources.ic_arrow_down_line;
            this.DownArrowPictureBox.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.Default;
            this.DownArrowPictureBox.Location = new System.Drawing.Point(300, 6);
            this.DownArrowPictureBox.Margin = new System.Windows.Forms.Padding(0);
            this.DownArrowPictureBox.Name = "DownArrowPictureBox";
            this.DownArrowPictureBox.Size = new System.Drawing.Size(18, 18);
            this.DownArrowPictureBox.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.DownArrowPictureBox.TabIndex = 2;
            this.DownArrowPictureBox.TabStop = false;
            this.DownArrowPictureBox.Click += new System.EventHandler(this.DownArrowPictureBox_Click);
            // 
            // AGLanguageListButton
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 15F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.Transparent;
            this.Controls.Add(this.DownArrowPictureBox);
            this.Controls.Add(this.LanguageValueLabel);
            this.Controls.Add(this.LanguageLabel);
            this.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.Margin = new System.Windows.Forms.Padding(4);
            this.Name = "AGLanguageListButton";
            this.Size = new System.Drawing.Size(331, 30);
            ((System.ComponentModel.ISupportInitialize)(this.DownArrowPictureBox)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private AGLabel LanguageLabel;
        private AGLabel LanguageValueLabel;
        private CustomControls.AGPictureBox DownArrowPictureBox;
    }
}
