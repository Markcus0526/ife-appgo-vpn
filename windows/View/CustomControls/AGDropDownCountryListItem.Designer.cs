namespace AppGo.View.CustomControls
{
    partial class AGDropDownCountryListItem
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
            this.CountryNameLabel = new AppGo.View.CustomControls.AGTransparentLabel();
            ((System.ComponentModel.ISupportInitialize)(this.CountryFlagPictureBox)).BeginInit();
            this.SuspendLayout();
            // 
            // CountryFlagPictureBox
            // 
            this.CountryFlagPictureBox.Enabled = false;
            this.CountryFlagPictureBox.Image = global::AppGo.Properties.Resources.ic_flag_br;
            this.CountryFlagPictureBox.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.High;
            this.CountryFlagPictureBox.Location = new System.Drawing.Point(6, 4);
            this.CountryFlagPictureBox.Margin = new System.Windows.Forms.Padding(3, 4, 3, 4);
            this.CountryFlagPictureBox.Name = "CountryFlagPictureBox";
            this.CountryFlagPictureBox.Size = new System.Drawing.Size(20, 20);
            this.CountryFlagPictureBox.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.CountryFlagPictureBox.TabIndex = 0;
            this.CountryFlagPictureBox.TabStop = false;
            // 
            // CountryNameLabel
            // 
            this.CountryNameLabel.BackColor = System.Drawing.Color.Transparent;
            this.CountryNameLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.CountryNameLabel.ForeColor = System.Drawing.Color.White;
            this.CountryNameLabel.Location = new System.Drawing.Point(27, 0);
            this.CountryNameLabel.Name = "CountryNameLabel";
            this.CountryNameLabel.Size = new System.Drawing.Size(100, 30);
            this.CountryNameLabel.TabIndex = 1;
            this.CountryNameLabel.Text = "Brazil";
            this.CountryNameLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // AGDropDownCountryListItem
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.Transparent;
            this.Controls.Add(this.CountryNameLabel);
            this.Controls.Add(this.CountryFlagPictureBox);
            this.Margin = new System.Windows.Forms.Padding(0);
            this.Name = "AGDropDownCountryListItem";
            this.Size = new System.Drawing.Size(130, 30);
            this.Resize += new System.EventHandler(this.DropDownServerListItem_Resize);
            ((System.ComponentModel.ISupportInitialize)(this.CountryFlagPictureBox)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private CustomControls.AGPictureBox CountryFlagPictureBox;
        private AGTransparentLabel CountryNameLabel;
    }
}
