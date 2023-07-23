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
    public partial class AGImageLabelButton : UserControl
    {
        private Bitmap OriginalImage = null;
        private Bitmap HighlightedImage = null;

        private Color OriginalTextColor = Color.FromArgb(55, 150, 198);
        private Color HighlightedTextColor = Color.FromArgb(37, 100, 132);

        private int Spacing = 5;

        public AGImageLabelButton()
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
            //Size must be set before location.
            ButtonTitleLabel.Size = new Size(Size.Width - ButtonImagePictureBox.Size.Width - Spacing, Size.Height);
            ButtonTitleLabel.Location = new Point(ButtonImagePictureBox.Size.Width + Spacing, 0);
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
            base.OnPaint(e);
            /*
            //is BackGroundImage null
            if (BackgroundImage != null)
            {
                e.Graphics.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality;
                e.Graphics.DrawImage(BackgroundImage, new System.Drawing.Rectangle(0, 0, Width, Height),
                    Location.X, Location.Y, Width, Height,
                    System.Drawing.GraphicsUnit.Pixel);
            } */
        }
    }
}
