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
    public partial class AGPhoneNoPrefixButtonControl : UserControl
    {
        private int LeftPadding = 0;
        private int RightPadding = 7;

        private PictureBox SplitterPictureBox;

        public AGPhoneNoPrefixButtonControl()
        {
            InitializeComponent();

            SplitterPictureBox = new PictureBox();
            SplitterPictureBox.BackColor = Color.FromArgb(0, 0, 0);
            Controls.Add(SplitterPictureBox);
  
            NumberLabel.ForeColor = Color.FromArgb(0, 0, 0);
            NumberLabel.Enabled = false;
        }

        private void AdjustSize()
        {
            DownArrowPictureBox.Location = new Point(Size.Width - RightPadding - DownArrowPictureBox.Size.Width, (Size.Height - DownArrowPictureBox.Size.Height) / 2);
            NumberLabel.Location = new Point(DownArrowPictureBox.Location.X - NumberLabel.Size.Width, (Size.Height - NumberLabel.Size.Height) / 2);
            SplitterPictureBox.Size = new Size(1, Size.Height - 10);
            SplitterPictureBox.Location = new Point(Size.Width - 1, 5);
        }

        public override string Text
        {
            get
            {
                return NumberLabel.Text;
            }

            set
            {
                NumberLabel.Text = value;
                AdjustSize();
            }
        }

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

        private void PhoneNoPrefixButtonControl_Resize(object sender, EventArgs e)
        {
            AdjustSize();
        }
    }
}
