namespace AppGo.View.CustomControls
{
    partial class AGNotificationListItem
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
            this.UpdatedAtLabel = new AppGo.View.CustomControls.AGLabel();
            this.ContentLabel = new AppGo.View.CustomControls.AGLabel();
            this.TitleLabel = new AppGo.View.CustomControls.AGLabel();
            this.SuspendLayout();
            // 
            // UpdatedAtLabel
            // 
            this.UpdatedAtLabel.AutoSize = true;
            this.UpdatedAtLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.UpdatedAtLabel.ForeColor = System.Drawing.Color.DeepSkyBlue;
            this.UpdatedAtLabel.Location = new System.Drawing.Point(212, 17);
            this.UpdatedAtLabel.Name = "UpdatedAtLabel";
            this.UpdatedAtLabel.Size = new System.Drawing.Size(76, 16);
            this.UpdatedAtLabel.TabIndex = 3;
            this.UpdatedAtLabel.Text = "Updated At";
            // 
            // ContentLabel
            // 
            this.ContentLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.ContentLabel.ForeColor = System.Drawing.Color.DeepSkyBlue;
            this.ContentLabel.Location = new System.Drawing.Point(133, 17);
            this.ContentLabel.Name = "ContentLabel";
            this.ContentLabel.Size = new System.Drawing.Size(73, 18);
            this.ContentLabel.TabIndex = 2;
            this.ContentLabel.Text = "Content";
            // 
            // TitleLabel
            // 
            this.TitleLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.TitleLabel.ForeColor = System.Drawing.Color.DeepSkyBlue;
            this.TitleLabel.Location = new System.Drawing.Point(70, 13);
            this.TitleLabel.Name = "TitleLabel";
            this.TitleLabel.Size = new System.Drawing.Size(45, 18);
            this.TitleLabel.TabIndex = 1;
            this.TitleLabel.Text = "Title";
            // 
            // AGNotificationListItem
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.White;
            this.Controls.Add(this.UpdatedAtLabel);
            this.Controls.Add(this.ContentLabel);
            this.Controls.Add(this.TitleLabel);
            this.ForeColor = System.Drawing.Color.DeepSkyBlue;
            this.Margin = new System.Windows.Forms.Padding(0);
            this.Name = "AGNotificationListItem";
            this.Size = new System.Drawing.Size(310, 50);
            this.Resize += new System.EventHandler(this.ServerListItem_Resize);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion
        private AGLabel TitleLabel;
        private AGLabel ContentLabel;
        private AGLabel UpdatedAtLabel;
    }
}
