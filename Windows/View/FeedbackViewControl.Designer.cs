namespace AppGo.View
{
    partial class FeedbackViewControl
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
            this.TitleBarControl = new AppGo.View.CustomControls.AGTitleBarControl();
            this.SuspendLayout();
            // 
            // TitleBarControl
            // 
            this.TitleBarControl.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(88)))), ((int)(((byte)(199)))), ((int)(((byte)(255)))));
            this.TitleBarControl.Location = new System.Drawing.Point(0, 0);
            this.TitleBarControl.Name = "TitleBarControl";
            this.TitleBarControl.Size = new System.Drawing.Size(380, 50);
            this.TitleBarControl.TabIndex = 0;
            this.TitleBarControl.Title = "Feedback";
            // 
            // FeedbackViewControl
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.White;
            this.Controls.Add(this.TitleBarControl);
            this.Name = "FeedbackViewControl";
            this.Size = new System.Drawing.Size(380, 570);
            this.ResumeLayout(false);

        }

        #endregion

        private CustomControls.AGTitleBarControl TitleBarControl;
    }
}
