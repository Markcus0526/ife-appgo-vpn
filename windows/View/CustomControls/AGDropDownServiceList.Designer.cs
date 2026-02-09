namespace AppGo.View.CustomControls
{
    partial class AGDropDownServiceList
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
            this.ServiceListFlowLayoutPanel = new System.Windows.Forms.FlowLayoutPanel();
            this.SuspendLayout();
            // 
            // ServiceListFlowLayoutPanel
            // 
            this.ServiceListFlowLayoutPanel.AutoScroll = true;
            this.ServiceListFlowLayoutPanel.Location = new System.Drawing.Point(0, 0);
            this.ServiceListFlowLayoutPanel.Margin = new System.Windows.Forms.Padding(0);
            this.ServiceListFlowLayoutPanel.Name = "ServiceListFlowLayoutPanel";
            this.ServiceListFlowLayoutPanel.Size = new System.Drawing.Size(300, 300);
            this.ServiceListFlowLayoutPanel.TabIndex = 5;
            // 
            // AGDropDownServiceList
            // 
            this.ClientSize = new System.Drawing.Size(306, 288);
            this.Controls.Add(this.ServiceListFlowLayoutPanel);
            this.Name = "AGDropDownServiceList";
            this.SizeChanged += new System.EventHandler(this.DropDownServerListControl_SizeChanged);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.FlowLayoutPanel ServiceListFlowLayoutPanel;
    }
}
