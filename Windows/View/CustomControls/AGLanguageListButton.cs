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

namespace AppGo.View.CustomControls
{

    public partial class AGLanguageListButton : UserControl
    {
        private string _Language = "";

        private bool _IsOpeningMenu = false;

        private Brush OriginalBrush = new SolidBrush(Color.FromArgb(221, 221, 221));
        private Brush HighlightedBrush = new SolidBrush(Color.FromArgb(147, 147, 147));
        private Brush CurrentBrush;

        public AGLanguageListButton()
        {
            InitializeComponent();

            Paint += new PaintEventHandler(_OnPaint);
            MouseDown += new MouseEventHandler(_OnMouseDown);
            MouseUp += new MouseEventHandler(_OnMouseUp);
            
            CurrentBrush = OriginalBrush;
        }

        private void _OnMouseDown(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
            {
                CurrentBrush = HighlightedBrush;
                //Invalidate();
            }
        }

        private void _OnMouseUp(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
            {
                CurrentBrush = OriginalBrush;
                //Invalidate();
            }
        }

        private void _OnPaint(object sender, PaintEventArgs e)
        {
            float CornerRadius = 5;

            if (IsOpeningMenu)
            {
                e.Graphics.FillEllipse(CurrentBrush, 0, -1, CornerRadius * 2, CornerRadius * 2);
                e.Graphics.FillEllipse(CurrentBrush, Size.Width - CornerRadius * 2, -1, CornerRadius * 2, CornerRadius * 2);
                e.Graphics.FillRectangle(CurrentBrush, CornerRadius, 0, Size.Width - CornerRadius * 2, CornerRadius);
                e.Graphics.FillRectangle(CurrentBrush, 0, CornerRadius - 1, Size.Width, Size.Height - CornerRadius + 1);
            }
            else
            {
                e.Graphics.FillEllipse(CurrentBrush, 0, -1, CornerRadius * 2, CornerRadius * 2);
                e.Graphics.FillEllipse(CurrentBrush, Size.Width - CornerRadius * 2, -1, CornerRadius * 2, CornerRadius * 2);
                e.Graphics.FillEllipse(CurrentBrush, 0, Size.Height - CornerRadius * 2, CornerRadius * 2, CornerRadius * 2);
                e.Graphics.FillEllipse(CurrentBrush, Size.Width - CornerRadius * 2, Size.Height - CornerRadius * 2, CornerRadius * 2, CornerRadius * 2);
                e.Graphics.FillRectangle(CurrentBrush, CornerRadius, 0, Size.Width - CornerRadius * 2, CornerRadius);
                e.Graphics.FillRectangle(CurrentBrush, 0, CornerRadius - 1, Size.Width, Size.Height - CornerRadius * 2 + 2);
                e.Graphics.FillRectangle(CurrentBrush, CornerRadius, Size.Height - CornerRadius, Size.Width - CornerRadius * 2, CornerRadius);
            }
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
                LanguageValueLabel.Text = _Language;
            }
        }

        public bool IsOpeningMenu
        {
            get
            {
                return _IsOpeningMenu;
            }

            set
            {
                _IsOpeningMenu = value;

                if (_IsOpeningMenu)
                {
                    DownArrowPictureBox.Image = Resources.ic_arrow_up_line;
                }
                else
                {
                    DownArrowPictureBox.Image = Resources.ic_arrow_down_line;
                }

                //Invalidate();
            }
        }

        public override string Text
        {
            get
            {
                return LanguageLabel.Text;
            }
            set
            {
                LanguageLabel.Text = value;
            }
        }

        private void DownArrowPictureBox_Click(object sender, EventArgs e)
        {
            this.OnClick(new EventArgs());
        }
    }
}
