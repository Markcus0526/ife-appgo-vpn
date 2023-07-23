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
    public partial class AGServiceListButton : UserControl
    {
        private AGService _Service = null;

        private Bitmap OriginalImage = null;
        private Bitmap HighlightedImage = null;

        public AGServiceListButton()
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
            CountryFlagPictureBox.Size = new Size(Size.Height - 10, Size.Height - 10);
            CountryFlagPictureBox.Location = new Point(7, (Size.Height - CountryFlagPictureBox.Size.Height) / 2);

            CountryNameLabel.Size = new Size(Size.Width - CountryFlagPictureBox.Location.X - CountryFlagPictureBox.Size.Width - 3, Size.Height);
            CountryNameLabel.Location = new Point(CountryFlagPictureBox.Location.X + CountryFlagPictureBox.Size.Width + 3, 0);

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

        public AGService Service
        {
            get
            {
                return _Service;
            }

            set
            {
                _Service = value;

                if (_Service != null)
                {
                    CountryName = CountryTemplate.GetCountryName(_Service.country.name);
                    CountryFlag = (Image)Resources.ResourceManager.GetObject(CountryTemplate.GetFlagName(_Service.country.name));
                }
            }
        }

        private string CountryName
        {
            get
            {
                return CountryNameLabel.Text;
            }
            set
            {
                CountryNameLabel.Text = value;
            }
        }

        private Image CountryFlag
        {
            get
            {
                return CountryFlagPictureBox.Image;
            }
            set
            {
                CountryFlagPictureBox.Image = value;
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

        public Color TextColor
        {
            get
            {
                return CountryNameLabel.ForeColor;
            }
            set
            {
                CountryNameLabel.ForeColor = value;
            }
        }

        private void ServerListButton_Resize(object sender, EventArgs e)
        {
            AdjustSize();
        }
    }
}
