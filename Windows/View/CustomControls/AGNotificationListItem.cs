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
    public partial class AGNotificationListItem : UserControl
    {
        private bool _IsLastItem = false;
        private AGNotificationData _Notification;
        private Pen SplitterPen;

        private Color OriginalBackColor = Color.FromArgb(88, 199, 255);
        private Color HighlightedBackColor = Color.FromArgb(59, 133, 170);

        public AGNotificationListItem()
        {
            InitializeComponent();

            SplitterPen = new Pen(Color.FromArgb(182, 241, 255));

            SizeChanged += new EventHandler(_SizeChanged);
            Paint += new PaintEventHandler(_OnPaint);
            MouseDown += new MouseEventHandler(_OnMouseDown);
            MouseUp += new MouseEventHandler(_OnMouseUp);

            AdjustSize();
        }

        private void _OnMouseDown(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
            {
                //BackColor = HighlightedBackColor;
            }
        }

        private void _OnMouseUp(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
            {
                //BackColor = OriginalBackColor;
            }
        }

        private void _SizeChanged(object sender, EventArgs e)
        {
            AdjustSize();
        }

        private void _OnPaint(object sender, PaintEventArgs e)
        {
            e.Graphics.DrawLine(SplitterPen, 0, Size.Height - 1, Size.Width, Size.Height - 1);
        }

        private void AdjustSize()
        {
            Graphics graphics = Graphics.FromHwnd(Handle);
            int HorizontalPadding = 10;
            int VerticalPadding = 5;

            int LabelWidth = Size.Width - 2 * HorizontalPadding;

            int TitleLabelHeight = (int) graphics.MeasureString(TitleLabel.Text, TitleLabel.Font, LabelWidth + 5).Height;
            TitleLabel.Size = new Size(LabelWidth, TitleLabelHeight + 10);
            TitleLabel.Location = new Point(HorizontalPadding, VerticalPadding);

            int ContentLabelHeight = (int)graphics.MeasureString(ContentLabel.Text, ContentLabel.Font, LabelWidth + 5).Height;
            ContentLabel.Size = new Size(LabelWidth, ContentLabelHeight + 10);
            ContentLabel.Location = new Point(HorizontalPadding, TitleLabel.Location.Y + TitleLabel.Size.Height);

            UpdatedAtLabel.Location = new Point(Size.Width - HorizontalPadding - UpdatedAtLabel.Width, ContentLabel.Location.Y + ContentLabel.Size.Height);

            Size = new Size(Size.Width, UpdatedAtLabel.Location.Y + UpdatedAtLabel.Size.Height + VerticalPadding);
        }

        private void ServerListItem_Resize(object sender, EventArgs e)
        {
            AdjustSize();
        }

        public AGNotificationData Notification
        {
            get
            {
                return _Notification;
            }
            set
            {
                _Notification = value;
                TitleLabel.Text = _Notification.title;
                ContentLabel.Text = _Notification.content;
                UpdatedAtLabel.Text = _Notification.updated_at;
                AdjustSize();
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
    }
}
