namespace AppGo.View.CustomControls
{
    partial class AGDropDownPackageList
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
            this.ShopItemListFlowLayoutPanel = new System.Windows.Forms.FlowLayoutPanel();
            this.SuspendLayout();
            // 
            // ShopItemListFlowLayoutPanel
            // 
            this.ShopItemListFlowLayoutPanel.AutoScroll = true;
            this.ShopItemListFlowLayoutPanel.Location = new System.Drawing.Point(0, 0);
            this.ShopItemListFlowLayoutPanel.Margin = new System.Windows.Forms.Padding(0);
            this.ShopItemListFlowLayoutPanel.Name = "ShopItemListFlowLayoutPanel";
            this.ShopItemListFlowLayoutPanel.Size = new System.Drawing.Size(300, 300);
            this.ShopItemListFlowLayoutPanel.TabIndex = 5;
            // 
            // AGDropDownPackageList
            // 
            this.ClientSize = new System.Drawing.Size(306, 289);
            this.Controls.Add(this.ShopItemListFlowLayoutPanel);
            this.Name = "AGDropDownPackageList";
            this.SizeChanged += new System.EventHandler(this.DropDownShopItemListControl_SizeChanged);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.FlowLayoutPanel ShopItemListFlowLayoutPanel;
    }
}
