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
    public partial class AGCheckboxSettingButton : UserControl
    {
        private bool _Checked = false;

        private Brush OriginalBrush = new SolidBrush(Color.FromArgb(221, 221, 221));
        private Brush HighlightedBrush = new SolidBrush(Color.FromArgb(147, 147, 147));
        private Brush CurrentBrush;

        public AGCheckboxSettingButton()
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
                Invalidate();
            }
        }

        private void _OnPaint(object sender, PaintEventArgs e)
        {
            float CornerRadius = 5;

            e.Graphics.FillEllipse(CurrentBrush, 0, -1, CornerRadius * 2, CornerRadius * 2);
            e.Graphics.FillEllipse(CurrentBrush, Size.Width - CornerRadius * 2, -1, CornerRadius * 2, CornerRadius * 2);
            e.Graphics.FillEllipse(CurrentBrush, 0, Size.Height - CornerRadius * 2, CornerRadius * 2, CornerRadius * 2);
            e.Graphics.FillEllipse(CurrentBrush, Size.Width - CornerRadius * 2, Size.Height - CornerRadius * 2, CornerRadius * 2, CornerRadius * 2);
            e.Graphics.FillRectangle(CurrentBrush, CornerRadius, 0, Size.Width - CornerRadius * 2, CornerRadius);
            e.Graphics.FillRectangle(CurrentBrush, 0, CornerRadius - 1, Size.Width, Size.Height - CornerRadius * 2 + 2);
            e.Graphics.FillRectangle(CurrentBrush, CornerRadius, Size.Height - CornerRadius, Size.Width - CornerRadius * 2, CornerRadius);
        }

        public bool Checked
        {
            get
            {
                return _Checked;
            }

            set
            {
                _Checked = value;
                CheckToggleButton.Selected = _Checked;
            }
        }

        public string Label
        {
            get
            {
                return SettingTitleLabel.Text;
            }

            set
            {
                SettingTitleLabel.Text = value;
            }
        }

        private void CheckToggleButton_Click(object sender, EventArgs e)
        {
            this.OnClick(new EventArgs());
        }
    }
}
