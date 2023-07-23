using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using AppGo.Properties;
using AppGo.Model;

namespace AppGo.View.CustomControls
{
    public partial class AGDropDownLanguageListItem : UserControl
    {
        private bool _Selected = false;
        private bool _IsLastItem = false;
        private string _Language;
        private Pen SplitterPen;

        private Brush OriginalBackColorBrush = new SolidBrush(Color.FromArgb(238, 238, 238));
        private Brush HighlightedBackColorBrush = new SolidBrush(Color.FromArgb(159, 159, 159));
        private Brush CurrentBackColorBrush;

        public AGDropDownLanguageListItem()
        {
            InitializeComponent();

            SplitterPen = new Pen(Color.FromArgb(220, 220, 220));
            CurrentBackColorBrush = OriginalBackColorBrush;

            Paint += new PaintEventHandler(_OnPaint);
            MouseDown += new MouseEventHandler(_OnMouseDown);
            MouseUp += new MouseEventHandler(_OnMouseUp);
            SizeChanged += new EventHandler(_SizeChanged);

            Selected = false;

            AdjustSize();
        }

        private void _OnMouseDown(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
            {
                CurrentBackColorBrush = HighlightedBackColorBrush;
                //Invalidate();
            }
        }

        private void _OnMouseUp(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
            {
                CurrentBackColorBrush = OriginalBackColorBrush;
                Invalidate();
            }
        }

        private void _OnPaint(object sender, PaintEventArgs e)
        {
            //if (!IsLastItem)
            //{
                e.Graphics.FillRectangle(CurrentBackColorBrush, 0, 0, Size.Width, Size.Height);
                e.Graphics.DrawLine(SplitterPen, 0, Size.Height - 1, Size.Width, Size.Height - 1);
            /*}
            else
            {
                float CornerRadius = 5;

                e.Graphics.FillEllipse(CurrentBackColorBrush, 0, -1, CornerRadius * 2, CornerRadius * 2);
                e.Graphics.FillEllipse(CurrentBackColorBrush, Size.Width - CornerRadius * 2, -1, CornerRadius * 2, CornerRadius * 2);
                e.Graphics.FillRectangle(CurrentBackColorBrush, CornerRadius, 0, Size.Width - CornerRadius * 2, CornerRadius);
                e.Graphics.FillRectangle(CurrentBackColorBrush, 0, CornerRadius - 1, Size.Width, Size.Height - CornerRadius + 1);
            }*/
        }

        private void _SizeChanged(object sender, EventArgs e)
        {
            AdjustSize();
        }

        private void AdjustSize()
        {
            LanguageNameLabel.Location = new Point(LanguageNameLabel.Location.X, (Size.Height - LanguageNameLabel.Size.Height) / 2 - 1);
            LanguageNameLabel.Size = new Size(Size.Width - LanguageNameLabel.Location.X, Size.Height);
        }

        public string Language
        {
            get
            {
                return _Language;
            }
            set
            {
                _Language = value;
                LanguageNameLabel.Text = _Language;
            }
        }

        public bool Selected
        {
            get
            {
                return _Selected;
            }

            set
            {
                _Selected = value;
                SelectionIndicatorPictureBox.Image = Selected ? Resources.ic_checked_blue : Resources.ic_unchecked;
            }
        }

        public bool IsLastItem
        {
            get
            {
                return _IsLastItem;
            }

            set
            {
                _IsLastItem = value;
                Invalidate();
            }
        }

        
        private void AGDropDownLanguageListItem_Resize(object sender, EventArgs e)
        {
            AdjustSize();
        }
    }
}
