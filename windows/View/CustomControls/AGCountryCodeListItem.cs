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
using AppGo.Controller;
using AppGo.Model;

namespace AppGo.View.CustomControls
{
    public partial class AGCountryCodeListItem : UserControl
    {
        private bool _Selected = false;
        private bool _IsLastItem = false;
        private CountryInfo _CountryInfo;
        private Pen SplitterPen;

        private Color OriginalBackColor = Color.FromArgb(88, 199, 255);
        private Color HighlightedBackColor = Color.FromArgb(59, 133, 170);

        public AGCountryCodeListItem()
        {
            InitializeComponent();

            SplitterPen = new Pen(Color.FromArgb(182, 241, 255));

            SizeChanged += new EventHandler(_SizeChanged);
            Paint += new PaintEventHandler(_OnPaint);
            MouseDown += new MouseEventHandler(_OnMouseDown);
            MouseUp += new MouseEventHandler(_OnMouseUp);

            Selected = false;
            AdjustSize();
        }

        private void _OnMouseDown(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
            {
                BackColor = HighlightedBackColor;
            }
        }

        private void _OnMouseUp(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
            {
                BackColor = OriginalBackColor;
            }
        }

        private void _SizeChanged(object sender, EventArgs e)
        {
            AdjustSize();
        }

        private void _OnPaint(object sender, PaintEventArgs e)
        {
            e.Graphics.DrawLine(SplitterPen, 15, Size.Height - 1, Size.Width - 15, Size.Height - 1);
        }

        private void AdjustSize()
        {
            CountryFlagPictureBox.Size = new Size(Size.Height - 20, Size.Height - 20);
            CountryFlagPictureBox.Location = new Point(15, 10);

            CountryNameLabel.Location = new Point(CountryFlagPictureBox.Location.X + CountryFlagPictureBox.Size.Width + 5, (Size.Height - CountryNameLabel.Height) / 2);

            SelectionStateIndicatorPictureBox.Location = new Point(Size.Width - 20 - SelectionStateIndicatorPictureBox.Size.Width, (Size.Height - SelectionStateIndicatorPictureBox.Size.Height) / 2);

            CountryCodeLabel.Location = new Point(SelectionStateIndicatorPictureBox.Location.X - 10 - CountryCodeLabel.Size.Width, (Size.Height - CountryCodeLabel.Height) / 2);
        }

        private void CountryCodeListItem_Resize(object sender, EventArgs e)
        {
            AdjustSize();
        }

        public CountryInfo CountryInfo
        {
            get
            {
                return _CountryInfo;
            }
            set
            {
                _CountryInfo = value;
                CountryCodeLabel.Text = _CountryInfo.PhoneCode;
                CountryNameLabel.Text = CountryTemplate.GetCountryName(_CountryInfo.Code);
                CountryFlagPictureBox.Image = (Image) Resources.ResourceManager.GetObject(_CountryInfo.Flag);
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
                SelectionStateIndicatorPictureBox.Image = _Selected ? Resources.ic_checked : Resources.ic_unchecked;
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

        public int Index { get; set; }
    }
}
