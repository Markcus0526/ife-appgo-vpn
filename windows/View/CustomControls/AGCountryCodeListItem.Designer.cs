namespace AppGo.View.CustomControls
{
    partial class AGCountryCodeListItem
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
            this.SelectionStateIndicatorPictureBox = new AppGo.View.CustomControls.AGPictureBox();
            this.CountryCodeLabel = new AppGo.View.CustomControls.AGLabel();
            this.CountryNameLabel = new AppGo.View.CustomControls.AGLabel();
            ((System.ComponentModel.ISupportInitialize)(this.CountryFlagPictureBox)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.SelectionStateIndicatorPictureBox)).BeginInit();
            this.SuspendLayout();
            // 
            // CountryFlagPictureBox
            // 
            this.CountryFlagPictureBox.Enabled = false;
            this.CountryFlagPictureBox.Image = global::AppGo.Properties.Resources.ic_flag_br;
            this.CountryFlagPictureBox.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.Default;
            this.CountryFlagPictureBox.Location = new System.Drawing.Point(20, 8);
            this.CountryFlagPictureBox.Name = "CountryFlagPictureBox";
            this.CountryFlagPictureBox.Size = new System.Drawing.Size(30, 25);
            this.CountryFlagPictureBox.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.CountryFlagPictureBox.TabIndex = 0;
            this.CountryFlagPictureBox.TabStop = false;
            // 
            // SelectionStateIndicatorPictureBox
            // 
            this.SelectionStateIndicatorPictureBox.Enabled = false;
            this.SelectionStateIndicatorPictureBox.Image = global::AppGo.Properties.Resources.ic_checked;
            this.SelectionStateIndicatorPictureBox.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.Default;
            this.SelectionStateIndicatorPictureBox.Location = new System.Drawing.Point(290, 17);
            this.SelectionStateIndicatorPictureBox.Name = "SelectionStateIndicatorPictureBox";
            this.SelectionStateIndicatorPictureBox.Size = new System.Drawing.Size(10, 8);
            this.SelectionStateIndicatorPictureBox.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.SelectionStateIndicatorPictureBox.TabIndex = 2;
            this.SelectionStateIndicatorPictureBox.TabStop = false;
            // 
            // CountryCodeLabel
            // 
            this.CountryCodeLabel.AutoSize = true;
            this.CountryCodeLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.CountryCodeLabel.ForeColor = System.Drawing.Color.White;
            this.CountryCodeLabel.Location = new System.Drawing.Point(243, 17);
            this.CountryCodeLabel.Name = "CountryCodeLabel";
            this.CountryCodeLabel.Size = new System.Drawing.Size(35, 13);
            this.CountryCodeLabel.TabIndex = 3;
            this.CountryCodeLabel.Text = "+860";
            // 
            // CountryNameLabel
            // 
            this.CountryNameLabel.AutoSize = true;
            this.CountryNameLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.CountryNameLabel.ForeColor = System.Drawing.Color.White;
            this.CountryNameLabel.Location = new System.Drawing.Point(70, 11);
            this.CountryNameLabel.Name = "CountryNameLabel";
            this.CountryNameLabel.Size = new System.Drawing.Size(49, 13);
            this.CountryNameLabel.TabIndex = 1;
            this.CountryNameLabel.Text = "Brazil";
            // 
            // AGCountryCodeListItem
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 11F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(88)))), ((int)(((byte)(199)))), ((int)(((byte)(255)))));
            this.Controls.Add(this.CountryCodeLabel);
            this.Controls.Add(this.SelectionStateIndicatorPictureBox);
            this.Controls.Add(this.CountryNameLabel);
            this.Controls.Add(this.CountryFlagPictureBox);
            this.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.Margin = new System.Windows.Forms.Padding(0);
            this.Name = "AGCountryCodeListItem";
            this.Size = new System.Drawing.Size(310, 42);
            this.Resize += new System.EventHandler(this.CountryCodeListItem_Resize);
            ((System.ComponentModel.ISupportInitialize)(this.CountryFlagPictureBox)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.SelectionStateIndicatorPictureBox)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private CustomControls.AGPictureBox CountryFlagPictureBox;
        private AGLabel CountryNameLabel;
        private CustomControls.AGPictureBox SelectionStateIndicatorPictureBox;
        private AGLabel CountryCodeLabel;
    }
}
