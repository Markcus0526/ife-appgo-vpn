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
    public partial class AGProgressBar : UserControl
    {
        private int nProgress = 0;

        private Brush YellowBrush = new SolidBrush(Color.FromArgb(255, 228, 1));
        private Brush GreyBrush = new SolidBrush(Color.FromArgb(238, 238, 238));

        public AGProgressBar()
        {
            InitializeComponent();

            Paint += new PaintEventHandler(AGProgressBar_OnPaint);
        }

        private void AGProgressBar_OnPaint(object sender, PaintEventArgs e)
        {
            float radius = Size.Height / 2 + 1;

            e.Graphics.FillRectangle(GreyBrush, radius, 0, Size.Width - radius * 2, Size.Height);
            e.Graphics.FillEllipse(GreyBrush, 0, -1, radius * 2, radius * 2);
            e.Graphics.FillEllipse(GreyBrush, Size.Width - radius * 2, -1, radius * 2, radius * 2);

            float progressWidth = Size.Width * nProgress / 100;

            if (progressWidth >= radius * 2)
            {
                e.Graphics.FillRectangle(YellowBrush, radius, 0, progressWidth - radius * 2, Size.Height);
                e.Graphics.FillEllipse(YellowBrush, 0, -1, radius * 2, radius * 2);
                e.Graphics.FillEllipse(YellowBrush, progressWidth - radius * 2, -1, radius * 2, radius * 2);
            }
            else if (progressWidth > 0)
            {
                e.Graphics.FillEllipse(YellowBrush, 0, -1, radius * 2, radius * 2);
            }
        }

        public int Progress
        {
            get
            {
                return nProgress;
            }
            set
            {
                nProgress = value;
                this.Invalidate();
            }
        }
    }
}
