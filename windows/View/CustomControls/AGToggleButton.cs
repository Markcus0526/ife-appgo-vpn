using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace AppGo.View.CustomControls
{
    public class AGToggleButton : Button
    {
        private bool _selected = false;

        private Brush SelectedBrush = new SolidBrush(Color.FromArgb(88, 199, 255));
        private Brush UnselectedBrush = new SolidBrush(Color.FromArgb(221, 221, 221));
        private Brush CurrentBrush;

        private Brush SelectedForeColorBrush = new SolidBrush(Color.White);
        private Brush UnselectedForeColorBrush = new SolidBrush(Color.FromArgb(170, 170, 170));
        private Brush CurrentForeColorBrush;

        public AGToggleButton()
        {
            BackColor = Color.White;
            CurrentBrush = UnselectedBrush;
            CurrentForeColorBrush = UnselectedForeColorBrush;
            Paint += new PaintEventHandler(AGToggleButton_OnPaint);
            MouseDown += new MouseEventHandler(_OnMouseDown);
            MouseUp += new MouseEventHandler(_OnMouseUp);
        }

        private void _OnMouseDown(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
            {
                CurrentBrush = new SolidBrush(Color.FromArgb(155, 210, 238));
                CurrentForeColorBrush = new SolidBrush(Color.FromArgb(213, 213, 213));
                Invalidate();
            }
        }

        private void _OnMouseUp(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
            {
                if (Selected)
                {
                    CurrentBrush = SelectedBrush;
                    CurrentForeColorBrush = SelectedForeColorBrush;
                }
                else
                {
                    CurrentBrush = UnselectedBrush;
                    CurrentForeColorBrush = UnselectedForeColorBrush;
                }

                Invalidate();
            }
        }

        private void AGToggleButton_OnPaint(object sender, PaintEventArgs e)
        {
            float radius = Size.Height / 2 + 1;

            e.Graphics.FillRectangle(CurrentBrush, radius, 0, Size.Width - radius * 2, Size.Height);
            e.Graphics.FillEllipse(CurrentBrush, 0, -1, radius * 2, radius * 2);
            e.Graphics.FillEllipse(CurrentBrush, Size.Width - radius * 2, -1, radius * 2, radius * 2);

            SizeF StringSize = e.Graphics.MeasureString(Text, Font);
            float StringX = (Size.Width - StringSize.Width) / 2 + 1;
            float StringY = (Size.Height - StringSize.Height) / 2;
            e.Graphics.DrawString(Text, Font, CurrentForeColorBrush, new RectangleF(StringX, StringY, StringSize.Width, StringSize.Height));
        }

        public bool Selected
        {
            get
            {
                return _selected;
            }
            set
            {
                _selected = value;

                if (_selected)
                {
                    CurrentBrush = SelectedBrush;
                    CurrentForeColorBrush = SelectedForeColorBrush;
                }
                else
                {
                    CurrentBrush = UnselectedBrush;
                    CurrentForeColorBrush = UnselectedForeColorBrush;
                }

                Invalidate();
            }
        }
    }
}
