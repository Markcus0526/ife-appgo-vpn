namespace AppGo.View.CustomControls
{
    partial class AGRoundTextBox
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
            this.PlaceholderTextBox = new AppGo.View.CustomControls.AGPlaceholderTextBox();
            this.SuspendLayout();
            // 
            // PlaceholderTextBox
            // 
            this.PlaceholderTextBox.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.PlaceholderTextBox.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(170)))), ((int)(((byte)(170)))), ((int)(((byte)(170)))));
            this.PlaceholderTextBox.Location = new System.Drawing.Point(26, 7);
            this.PlaceholderTextBox.Margin = new System.Windows.Forms.Padding(0);
            this.PlaceholderTextBox.Name = "PlaceholderTextBox";
            this.PlaceholderTextBox.Size = new System.Drawing.Size(252, 16);
            this.PlaceholderTextBox.TabIndex = 0;
            this.PlaceholderTextBox.FontChanged += new System.EventHandler(this.placeholderTextBox_FontChanged);
            // 
            // AGRoundTextBox
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.White;
            this.BackgroundImage = global::AppGo.Properties.Resources.ic_textfield_background;
            this.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.Controls.Add(this.PlaceholderTextBox);
            this.DoubleBuffered = true;
            this.Margin = new System.Windows.Forms.Padding(0);
            this.Name = "AGRoundTextBox";
            this.Size = new System.Drawing.Size(300, 30);
            this.Resize += new System.EventHandler(this.AGTextBox_Resize);
            this.ResumeLayout(false);

        }

        #endregion

        private AGPlaceholderTextBox PlaceholderTextBox;
    }
}
