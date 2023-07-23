using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Drawing.Drawing2D;

namespace AppGo.View.CustomControls
{
    public partial class AGImageAboveLabelButton : UserControl
    {
        private Bitmap OriginalImage = null;
        private Bitmap HighlightedImage = null;

        private Color OriginalTextColor = Color.FromArgb(55, 150, 198);
        private Color HighlightedTextColor = Color.FromArgb(37, 100, 132);

        private int Spacing = 5;

        public AGImageAboveLabelButton()
        {
            InitializeComponent();

            MouseDown += new MouseEventHandler(_OnMouseDown);
            MouseUp += new MouseEventHandler(_OnMouseUp);
            ButtonTitleLabel.MouseDown += new MouseEventHandler(_OnMouseDown);
            ButtonTitleLabel.MouseUp += new MouseEventHandler(_OnMouseUp);
            ButtonTitleLabel.Click += new EventHandler(_OnLabelClick);

            AdjustSize();
        }

        private void _OnLabelClick(object sender, EventArgs e)
        {
            OnClick(e);
        }

        private void _OnMouseDown(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
            {
                Image = HighlightedImage;
                ButtonTitleLabel.ForeColor = HighlightedTextColor;
            }
        }

        private void _OnMouseUp(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
            {
                if (OriginalImage != null)
                {
                    Image = OriginalImage;
                }

                if (OriginalTextColor != Color.Transparent)
                {
                    ButtonTitleLabel.ForeColor = OriginalTextColor;
                }
            }
        }

        private void AdjustSize()
        {
            //Size must be set before location
            ButtonImagePictureBox.Location = new Point((Size.Width - ButtonImagePictureBox.Size.Width) / 2, 0);
            ButtonTitleLabel.Location = new Point((Size.Width - ButtonTitleLabel.Size.Width) / 2, ButtonImagePictureBox.Size.Height + Spacing);
        }

        private void AGImageLabelButton_Resize(object sender, EventArgs e)
        {
            AdjustSize();
        }

        public string LabelText
        {
            get
            {
                return ButtonTitleLabel.Text;
            }

            set
            {
                ButtonTitleLabel.Text = value;
                AdjustSize();
            }
        }

        public Image Image
        {
            get
            {
                return ButtonImagePictureBox.BackgroundImage;
            }

            set
            {
                if (HighlightedImage == null && value != null)
                {
                    OriginalImage = new Bitmap(value);
                    HighlightedImage = new Bitmap(value);
                    int x, y;

                    // Loop through the images pixels to reset color. 
                    for (x = 0; x < HighlightedImage.Width; x++)
                    {
                        for (y = 0; y < HighlightedImage.Height; y++)
                        {
                            Color pixelColor = HighlightedImage.GetPixel(x, y);
                            Color newColor = Color.FromArgb(pixelColor.A, pixelColor.R * 2 / 3, pixelColor.G * 2 / 3, pixelColor.B * 2 / 3);
                            HighlightedImage.SetPixel(x, y, newColor);
                        }
                    }
                }

                ButtonImagePictureBox.BackgroundImage = value;
            }
        }

        public InterpolationMode InterpolationMode { get; set; }

        protected override void OnPaint(PaintEventArgs e)
        {
            e.Graphics.InterpolationMode = InterpolationMode;

            //is BackGroundImage null
            if (this.BackgroundImage != null)
            {

                e.Graphics.DrawImage(this.BackgroundImage, new System.Drawing.Rectangle(0, 0, this.Width, this.Height),
                this.Location.X, this.Location.Y, this.Width, this.Height,
                   System.Drawing.GraphicsUnit.Pixel);
            }

            e.Graphics.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality;
            SolidBrush drawBrush = new SolidBrush(this.ForeColor);
            e.Graphics.DrawString(this.Text, this.Font, drawBrush, new System.Drawing.Rectangle(0, 0, this.Width, this.Height));
            //base.OnPaint(e);
        }
    }
}
