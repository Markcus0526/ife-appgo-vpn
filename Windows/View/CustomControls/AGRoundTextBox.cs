using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace AppGo.View.CustomControls
{
    public partial class AGRoundTextBox : UserControl
    {

        private int LeftPadding = 10;
        private int RightPadding = 10;

        public AGRoundTextBox()
        {
            InitializeComponent();
        }

        private void AdjustSize()
        {
            //Size must be set before location.
            PlaceholderTextBox.Size = new Size(Size.Width - LeftPadding - RightPadding, 16);
            PlaceholderTextBox.Location = new Point(LeftPadding, (Size.Height - PlaceholderTextBox.Size.Height) / 2);
        }

        private void placeholderTextBox_FontChanged(object sender, EventArgs e)
        {
            AdjustSize();
        }

        private void AGTextBox_Resize(object sender, EventArgs e)
        {
            AdjustSize();
        }

        public string PlaceholderText
        {
            get { return PlaceholderTextBox.placeholder.Text; }
            set
            {
                PlaceholderTextBox.placeholder.Text = value;
            }
        }
        public override string Text => PlaceholderTextBox.Text;

        public void SetLeftPadding(int LeftPadding)
        {
            this.LeftPadding = LeftPadding;
            AdjustSize();
        }
        public void SetRightPadding(int RightPadding)
        {
            this.RightPadding = RightPadding;
            AdjustSize();
        }

        public void SetUseSystemPasswordChar(bool value)
        {
            PlaceholderTextBox.SetUseSystemPasswordChar(value);
        }
    }
}
