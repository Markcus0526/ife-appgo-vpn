namespace AppGo.View.CustomControls
{
    partial class AGDropDownLanguageListItem
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
            this.SelectionIndicatorPictureBox = new AppGo.View.CustomControls.AGPictureBox();
            this.LanguageNameLabel = new AppGo.View.CustomControls.AGTransparentLabel();
            ((System.ComponentModel.ISupportInitialize)(this.SelectionIndicatorPictureBox)).BeginInit();
            this.SuspendLayout();
            // 
            // SelectionIndicatorPictureBox
            // 
            this.SelectionIndicatorPictureBox.Enabled = false;
            this.SelectionIndicatorPictureBox.Image = global::AppGo.Properties.Resources.ic_checked_blue;
            this.SelectionIndicatorPictureBox.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.Default;
            this.SelectionIndicatorPictureBox.Location = new System.Drawing.Point(290, 9);
            this.SelectionIndicatorPictureBox.Margin = new System.Windows.Forms.Padding(3, 4, 3, 4);
            this.SelectionIndicatorPictureBox.Name = "SelectionIndicatorPictureBox";
            this.SelectionIndicatorPictureBox.Size = new System.Drawing.Size(12, 12);
            this.SelectionIndicatorPictureBox.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.SelectionIndicatorPictureBox.TabIndex = 0;
            this.SelectionIndicatorPictureBox.TabStop = false;
            // 
            // LanguageNameLabel
            // 
            this.LanguageNameLabel.BackColor = System.Drawing.Color.Transparent;
            this.LanguageNameLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.LanguageNameLabel.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(55)))), ((int)(((byte)(150)))), ((int)(((byte)(198)))));
            this.LanguageNameLabel.Location = new System.Drawing.Point(20, 0);
            this.LanguageNameLabel.Name = "LanguageNameLabel";
            this.LanguageNameLabel.Size = new System.Drawing.Size(0, 30);
            this.LanguageNameLabel.TabIndex = 1;
            this.LanguageNameLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // AGDropDownLanguageListItem
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.Transparent;
            this.Controls.Add(this.LanguageNameLabel);
            this.Controls.Add(this.SelectionIndicatorPictureBox);
            this.Margin = new System.Windows.Forms.Padding(0);
            this.Name = "AGDropDownLanguageListItem";
            this.Size = new System.Drawing.Size(310, 30);
            this.Resize += new System.EventHandler(this.AGDropDownLanguageListItem_Resize);
            ((System.ComponentModel.ISupportInitialize)(this.SelectionIndicatorPictureBox)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private CustomControls.AGPictureBox SelectionIndicatorPictureBox;
        private AGTransparentLabel LanguageNameLabel;
    }
}
