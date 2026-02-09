namespace AppGo.View.CustomControls
{
    partial class AGDropDownLanguageList
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
            this.LanguageMenuFlowLayoutPanel = new System.Windows.Forms.FlowLayoutPanel();
            this.SuspendLayout();
            // 
            // LanguageMenuFlowLayoutPanel
            // 
            this.LanguageMenuFlowLayoutPanel.AutoScroll = true;
            this.LanguageMenuFlowLayoutPanel.Location = new System.Drawing.Point(0, 0);
            this.LanguageMenuFlowLayoutPanel.Margin = new System.Windows.Forms.Padding(0);
            this.LanguageMenuFlowLayoutPanel.Name = "LanguageMenuFlowLayoutPanel";
            this.LanguageMenuFlowLayoutPanel.Size = new System.Drawing.Size(300, 300);
            this.LanguageMenuFlowLayoutPanel.TabIndex = 5;
            // 
            // AGDropDownLanguageMenuControl
            // 
            this.ClientSize = new System.Drawing.Size(294, 272);
            this.Controls.Add(this.LanguageMenuFlowLayoutPanel);
            this.Name = "AGDropDownLanguageMenuControl";
            this.SizeChanged += new System.EventHandler(this.DropDownLanguageMenuControl_SizeChanged);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.FlowLayoutPanel LanguageMenuFlowLayoutPanel;
    }
}
