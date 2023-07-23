namespace AppGo.View
{
    partial class TermsOfUseViewControl
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
            this.ContentTextBox = new System.Windows.Forms.TextBox();
            this.TitleBarControl = new AppGo.View.CustomControls.AGTitleBarControl();
            this.SuspendLayout();
            // 
            // ContentTextBox
            // 
            this.ContentTextBox.BackColor = System.Drawing.Color.White;
            this.ContentTextBox.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.ContentTextBox.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.ContentTextBox.ForeColor = System.Drawing.Color.DeepSkyBlue;
            this.ContentTextBox.Location = new System.Drawing.Point(14, 68);
            this.ContentTextBox.Multiline = true;
            this.ContentTextBox.Name = "ContentTextBox";
            this.ContentTextBox.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.ContentTextBox.Size = new System.Drawing.Size(363, 482);
            this.ContentTextBox.TabIndex = 1;
            // 
            // TitleBarControl
            // 
            this.TitleBarControl.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(88)))), ((int)(((byte)(199)))), ((int)(((byte)(255)))));
            this.TitleBarControl.Location = new System.Drawing.Point(0, 0);
            this.TitleBarControl.Name = "TitleBarControl";
            this.TitleBarControl.Size = new System.Drawing.Size(380, 50);
            this.TitleBarControl.TabIndex = 0;
            this.TitleBarControl.Title = "Terms of Use";
            // 
            // TermsOfUseViewControl
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.White;
            this.Controls.Add(this.ContentTextBox);
            this.Controls.Add(this.TitleBarControl);
            this.Name = "TermsOfUseViewControl";
            this.Size = new System.Drawing.Size(380, 570);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private CustomControls.AGTitleBarControl TitleBarControl;
        private System.Windows.Forms.TextBox ContentTextBox;
    }
}
