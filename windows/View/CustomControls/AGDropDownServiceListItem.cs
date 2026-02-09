using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using AppGo.Controller;
using AppGo.Properties;
using AppGo.Model;

namespace AppGo.View.CustomControls
{
    public partial class AGDropDownServiceListItem : UserControl
    {
        private bool _Selected = false;
        private bool _IsLastItem = false;
        private AGService _Service;
        private Pen SplitterPen;

        private Brush OriginalBackColorBrush = new SolidBrush(Color.FromArgb(163, 225, 254));
        private Brush HighlightedBackColorBrush = new SolidBrush(Color.FromArgb(49, 155, 209));

        private Brush OriginalSelectionBackColorBrush = new SolidBrush(Color.FromArgb(49, 155, 209));
        private Brush HighlightedSelectionBackColorBrush = new SolidBrush(Color.FromArgb(49, 155, 209));

        private Brush CurrentBackColorBrush;

        public AGDropDownServiceListItem()
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
                if (!Selected)
                    CurrentBackColorBrush = HighlightedBackColorBrush;
                else
                    CurrentBackColorBrush = HighlightedSelectionBackColorBrush;
                Invalidate();
            }
        }

        private void _OnMouseUp(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
            {
                if (!Selected)
                    CurrentBackColorBrush = OriginalBackColorBrush;
                else
                    CurrentBackColorBrush = OriginalSelectionBackColorBrush;
                Invalidate();
            }
        }

        private void _OnPaint(object sender, PaintEventArgs e)
        {
            e.Graphics.FillRectangle(CurrentBackColorBrush, 0, 0, Size.Width, Size.Height);

            if (!IsLastItem)
                e.Graphics.DrawLine(SplitterPen, 0, Size.Height - 1, Size.Width, Size.Height - 1);
        }

        private void _SizeChanged(object sender, EventArgs e)
        {
            AdjustSize();
        }

        private void AdjustSize()
        {
            CountryNameLabel.Location = new Point(CountryNameLabel.Location.X, (Size.Height - CountryNameLabel.Size.Height) / 2 - 1);
            CountryNameLabel.Size = new Size(Size.Width - CountryNameLabel.Location.X, Size.Height);
        }

        public AGService Service
        {
            get
            {
                return _Service;
            }
            set
            {
                _Service = value;
                if (LocalizationManager.CurrentLanguage == LocalizationManager.Chinese)
                {
                    CountryNameLabel.Text = CountryTemplate.GetCountryName(_Service.country.alias_zh);
                }
                else
                {
                    CountryNameLabel.Text = CountryTemplate.GetCountryName(_Service.country.alias_en);
                }                
                CountryFlagPictureBox.Image = (Image) Resources.ResourceManager.GetObject(CountryTemplate.GetFlagName(_Service.country.name));
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

                if (_Selected)
                {
                    CountryNameLabel.ForeColor = Color.White;
                    CurrentBackColorBrush = OriginalSelectionBackColorBrush;
                }
                else
                {
                    CountryNameLabel.ForeColor = Color.FromArgb(170, 170, 170);
                    CurrentBackColorBrush = OriginalBackColorBrush;
                }

                Invalidate();
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

        private void DropDownServerListItem_Resize(object sender, EventArgs e)
        {
            AdjustSize();
        }
    }
}
