using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Drawing;
using System.Drawing.Drawing2D;

namespace AppGo.View.CustomControls
{
    public class AGImageButton : Button
    {
        private Bitmap OriginalImage = null;
        private Bitmap HighlightedImage = null;

        private Color OriginalForeColor = Color.Transparent;
        private Color HighlightedForeColor = Color.Transparent;

        public AGImageButton()
        {
            FlatAppearance.BorderColor = Color.FromArgb(0, 255, 255, 255);

            MouseDown += new MouseEventHandler(_OnMouseDown);
            MouseUp += new MouseEventHandler(_OnMouseUp);
            BackgroundImageChanged += new EventHandler(_OnBackgroundImageChanged);
            ForeColorChanged += new EventHandler(_OnForeColorChanged);
        }

        private void _OnBackgroundImageChanged(object sender, EventArgs e)
        {            
            if (HighlightedImage == null && BackgroundImage != null)
            {
                OriginalImage = new Bitmap(BackgroundImage);
                HighlightedImage = new Bitmap(BackgroundImage);

                // Loop through the images pixels to reset color. 
                for (int x = 0; x < HighlightedImage.Width; x++)
                {
                    for (int y = 0; y < HighlightedImage.Height; y++)
                    {
                        Color pixelColor = HighlightedImage.GetPixel(x, y);
                        Color newColor = Color.FromArgb(pixelColor.A, pixelColor.R * 2 / 3, pixelColor.G * 2 / 3, pixelColor.B * 2 / 3);
                        HighlightedImage.SetPixel(x, y, newColor);
                    }
                }
            }
        }

        private void _OnForeColorChanged(object sender, EventArgs e)
        {
            if (HighlightedForeColor == Color.Transparent && ForeColor != Color.Transparent)
            {
                OriginalForeColor = Color.FromArgb(ForeColor.A, ForeColor.R, ForeColor.G, ForeColor.B);
                HighlightedForeColor = Color.FromArgb(ForeColor.A, ForeColor.R * 2 / 3, ForeColor.G * 2 / 3, ForeColor.B * 2 / 3);
            }
        }

        private void _OnMouseDown(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
            {
                BackgroundImage = HighlightedImage;
                ForeColor = HighlightedForeColor;
            }
        }

        private void _OnMouseUp(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
            {
                if (OriginalImage != null)
                {
                    BackgroundImage = OriginalImage;
                }

                if (OriginalForeColor != Color.Transparent)
                {
                    ForeColor = OriginalForeColor;
                }
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
