namespace AppGo.View.CustomControls
{
    partial class AGDropDownCountryList
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
            this.CountryListFlowLayoutPanel = new System.Windows.Forms.FlowLayoutPanel();
            this.SuspendLayout();
            // 
            // CountryListFlowLayoutPanel
            // 
            this.CountryListFlowLayoutPanel.AutoScroll = true;
            this.CountryListFlowLayoutPanel.BackColor = System.Drawing.Color.DeepSkyBlue;
            this.CountryListFlowLayoutPanel.Location = new System.Drawing.Point(0, 0);
            this.CountryListFlowLayoutPanel.Margin = new System.Windows.Forms.Padding(0);
            this.CountryListFlowLayoutPanel.Name = "CountryListFlowLayoutPanel";
            this.CountryListFlowLayoutPanel.Size = new System.Drawing.Size(300, 300);
            this.CountryListFlowLayoutPanel.TabIndex = 5;
            // 
            // AGDropDownCountryList
            // 
            this.ClientSize = new System.Drawing.Size(306, 288);
            this.Controls.Add(this.CountryListFlowLayoutPanel);
            this.Name = "AGDropDownCountryList";
            this.SizeChanged += new System.EventHandler(this.DropDownServerListControl_SizeChanged);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.FlowLayoutPanel CountryListFlowLayoutPanel;
    }
}
