namespace AppGo.View.CustomControls
{
    partial class AGMessageBoxForm
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

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.AppIconPictureBox = new AppGo.View.CustomControls.AGPictureBox();
            this.MessageLabel = new AppGo.View.CustomControls.AGLabel();
            this.OKButton = new AppGo.View.CustomControls.AGImageButton();
            this.CancelButton = new AppGo.View.CustomControls.AGImageButton();
            ((System.ComponentModel.ISupportInitialize)(this.AppIconPictureBox)).BeginInit();
            this.SuspendLayout();
            // 
            // AppIconPictureBox
            // 
            this.AppIconPictureBox.Enabled = false;
            this.AppIconPictureBox.Image = global::AppGo.Properties.Resources.ic_appicon_mark;
            this.AppIconPictureBox.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.Default;
            this.AppIconPictureBox.Location = new System.Drawing.Point(20, 15);
            this.AppIconPictureBox.Margin = new System.Windows.Forms.Padding(3, 4, 3, 4);
            this.AppIconPictureBox.Name = "AppIconPictureBox";
            this.AppIconPictureBox.Size = new System.Drawing.Size(70, 70);
            this.AppIconPictureBox.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.AppIconPictureBox.TabIndex = 8;
            this.AppIconPictureBox.TabStop = false;
            // 
            // MessageLabel
            // 
            this.MessageLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.MessageLabel.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(55)))), ((int)(((byte)(150)))), ((int)(((byte)(198)))));
            this.MessageLabel.Location = new System.Drawing.Point(108, 15);
            this.MessageLabel.Name = "MessageLabel";
            this.MessageLabel.Size = new System.Drawing.Size(289, 70);
            this.MessageLabel.TabIndex = 9;
            this.MessageLabel.Text = "This is a test message";
            this.MessageLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // OKButton
            // 
            this.OKButton.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.OKButton.BackColor = System.Drawing.Color.Transparent;
            this.OKButton.BackgroundImage = global::AppGo.Properties.Resources.ic_button_background_small;
            this.OKButton.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.OKButton.FlatAppearance.BorderSize = 0;
            this.OKButton.FlatAppearance.MouseDownBackColor = System.Drawing.Color.White;
            this.OKButton.FlatAppearance.MouseOverBackColor = System.Drawing.Color.White;
            this.OKButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.OKButton.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(136)));
            this.OKButton.ForeColor = System.Drawing.Color.White;
            this.OKButton.Location = new System.Drawing.Point(292, 98);
            this.OKButton.Margin = new System.Windows.Forms.Padding(0);
            this.OKButton.Name = "OKButton";
            this.OKButton.Size = new System.Drawing.Size(100, 28);
            this.OKButton.TabIndex = 7;
            this.OKButton.TabStop = false;
            this.OKButton.Text = "OK";
            this.OKButton.TextImageRelation = System.Windows.Forms.TextImageRelation.TextAboveImage;
            this.OKButton.UseVisualStyleBackColor = false;
            this.OKButton.Click += new System.EventHandler(this.OKButton_Click);
            // 
            // CancelButton
            // 
            this.CancelButton.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.CancelButton.BackColor = System.Drawing.Color.Transparent;
            this.CancelButton.BackgroundImage = global::AppGo.Properties.Resources.ic_button_background_small;
            this.CancelButton.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.CancelButton.FlatAppearance.BorderSize = 0;
            this.CancelButton.FlatAppearance.MouseDownBackColor = System.Drawing.Color.White;
            this.CancelButton.FlatAppearance.MouseOverBackColor = System.Drawing.Color.White;
            this.CancelButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.CancelButton.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(136)));
            this.CancelButton.ForeColor = System.Drawing.Color.White;
            this.CancelButton.Location = new System.Drawing.Point(176, 98);
            this.CancelButton.Margin = new System.Windows.Forms.Padding(0);
            this.CancelButton.Name = "CancelButton";
            this.CancelButton.Size = new System.Drawing.Size(100, 28);
            this.CancelButton.TabIndex = 10;
            this.CancelButton.TabStop = false;
            this.CancelButton.Text = "Cancel";
            this.CancelButton.TextImageRelation = System.Windows.Forms.TextImageRelation.TextAboveImage;
            this.CancelButton.UseVisualStyleBackColor = false;
            this.CancelButton.Visible = false;
            this.CancelButton.Click += new System.EventHandler(this.CancelButton_Click);
            // 
            // AGMessageBoxForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.White;
            this.ClientSize = new System.Drawing.Size(409, 142);
            this.Controls.Add(this.CancelButton);
            this.Controls.Add(this.MessageLabel);
            this.Controls.Add(this.AppIconPictureBox);
            this.Controls.Add(this.OKButton);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Margin = new System.Windows.Forms.Padding(3, 4, 3, 4);
            this.MaximizeBox = false;
            this.Name = "AGMessageBoxForm";
            this.Text = "AppGo";
            ((System.ComponentModel.ISupportInitialize)(this.AppIconPictureBox)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private CustomControls.AGImageButton OKButton;
        private CustomControls.AGPictureBox AppIconPictureBox;
        private CustomControls.AGLabel MessageLabel;
        private AGImageButton CancelButton;
    }
}