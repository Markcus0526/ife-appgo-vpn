namespace AppGo.View.CustomControls
{
    partial class AGDropDownPackageListItem
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
            this.ItemNameLabel = new AppGo.View.CustomControls.AGTransparentLabel();
            this.SuspendLayout();
            // 
            // ItemNameLabel
            // 
            this.ItemNameLabel.BackColor = System.Drawing.Color.Transparent;
            this.ItemNameLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.ItemNameLabel.ForeColor = System.Drawing.Color.White;
            this.ItemNameLabel.Location = new System.Drawing.Point(5, -1);
            this.ItemNameLabel.Name = "ItemNameLabel";
            this.ItemNameLabel.Size = new System.Drawing.Size(302, 21);
            this.ItemNameLabel.TabIndex = 1;
            this.ItemNameLabel.Text = "Brazil";
            this.ItemNameLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // AGDropDownPackageListItem
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.Transparent;
            this.Controls.Add(this.ItemNameLabel);
            this.Margin = new System.Windows.Forms.Padding(0);
            this.Name = "AGDropDownPackageListItem";
            this.Size = new System.Drawing.Size(310, 24);
            this.Resize += new System.EventHandler(this.DropDownShopItemListItem_Resize);
            this.ResumeLayout(false);

        }

        #endregion
        private AGTransparentLabel ItemNameLabel;
    }
}
