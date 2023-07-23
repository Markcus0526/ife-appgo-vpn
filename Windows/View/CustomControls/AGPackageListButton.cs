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
using AppGo.Model;
using AppGo.Properties;

namespace AppGo.View.CustomControls
{
    public partial class AGPackageListButton : UserControl
    {
        private Bitmap OriginalImage = null;
        private Bitmap HighlightedImage = null;

        public AGPackageListButton()
        {
            InitializeComponent();

            MouseDown += new MouseEventHandler(_OnMouseDown);
            MouseUp += new MouseEventHandler(_OnMouseUp);
            BackgroundImageChanged += new EventHandler(_OnBackgroundImageChanged);
        }

        private void _OnBackgroundImageChanged(object sender, EventArgs e)
        {
            if (HighlightedImage == null && BackgroundImage != null)
            {
                OriginalImage = new Bitmap(BackgroundImage);
                HighlightedImage = new Bitmap(BackgroundImage);
                int x, y;

                // Loop through the images pixels to reset color. 
                for (x = 0; x < HighlightedImage.Width; x++)
                {
                    for (y = 0; y < HighlightedImage.Height; y++)
                    {
                        Color pixelColor = HighlightedImage.GetPixel(x, y);
                        Color newColor = Color.FromArgb(pixelColor.A, pixelColor.R * 3 / 4, pixelColor.G * 3 / 4, pixelColor.B * 3 / 4);
                        HighlightedImage.SetPixel(x, y, newColor);
                    }
                }
            }
        }

        private void AdjustSize()
        {
            ItemNameLabel.Size = new Size(Size.Width - 5, Size.Height);
            ItemNameLabel.Location = new Point(5, 0);
            DownArrowPictureBox.Location = new Point(Size.Width - DownArrowPictureBox.Size.Width - 7, (Size.Height - DownArrowPictureBox.Size.Height) / 2);
        }

        private void _OnMouseDown(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
            {
                BackgroundImage = HighlightedImage;
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
            }
        }

        public Image DownArrowImage
        {
            get
            {
                return DownArrowPictureBox.Image;
            }
            set
            {
                DownArrowPictureBox.Image = value;
            }
        }

        public string Title
        {
            get
            {
                return ItemNameLabel.Text;
            }
            set
            {
                ItemNameLabel.Text = value;
            }
        }


        private void ShopItemListButton_Resize(object sender, EventArgs e)
        {
            AdjustSize();
        }

        private void DownArrowPictureBox_Click(object sender, EventArgs e)
        {
            this.OnClick(new EventArgs());
        }
    }
}
