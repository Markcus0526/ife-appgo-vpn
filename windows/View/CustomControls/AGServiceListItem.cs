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
    public partial class AGServiceListItem : UserControl
    {
        private bool _Selected = false;
        private bool _IsLastItem = false;
        private AGService _Server;
        private Pen SplitterPen;

        private Color OriginalBackColor = Color.FromArgb(88, 199, 255);
        private Color HighlightedBackColor = Color.FromArgb(59, 133, 170);

        public AGServiceListItem()
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
            ServerNameLabel.Location = new Point(20, (Size.Height - ServerNameLabel.Height) / 2);

            SelectionStateIndicatorPictureBox.Location = new Point(Size.Width - 20 - SelectionStateIndicatorPictureBox.Size.Width, (Size.Height - SelectionStateIndicatorPictureBox.Size.Height) / 2);

            PingTimeLabel.Location = new Point(SelectionStateIndicatorPictureBox.Location.X - 10 - PingTimeLabel.Size.Width, (Size.Height - PingTimeLabel.Height) / 2);
        }

        private void ServerListItem_Resize(object sender, EventArgs e)
        {
            AdjustSize();
        }

        public AGService Server
        {
            get
            {
                return _Server;
            }
            set
            {
                _Server = value;

                if (_Server.delay == 0)
                {
                    PingTimeLabel.Text = "-";
                }
                else if (_Server.delay == -1)
                {
                    PingTimeLabel.Text = LocalizationManager.GetString("overtime");
                }
                else
                {
                    PingTimeLabel.Text = _Server.delay + "ms";
                }

                if (LocalizationManager.CurrentLanguage == LocalizationManager.Chinese)
                {
                    ServerNameLabel.Text = CountryTemplate.GetCountryName(_Server.country.alias_zh);
                }
                else
                {
                    ServerNameLabel.Text = CountryTemplate.GetCountryName(_Server.country.alias_en);
                }
                
                AdjustSize();
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
