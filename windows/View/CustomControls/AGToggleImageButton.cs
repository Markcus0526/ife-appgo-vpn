using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using AppGo.Properties;

namespace AppGo.View.CustomControls
{

    public class AGToggleImageButton : Button
    {

        public string HiddenText = "";
        private bool _selected = false;

        private Image _NormalImage = Resources.ic_flag_user;
        private Bitmap _NormalHighlightImage = Resources.ic_flag_user;

        private Image _SelectedImage = Resources.ic_flag_user;
        private Bitmap _SelectedHighlightImage = Resources.ic_flag_user;

        public AGToggleImageButton()
        {
            BackgroundImageLayout = ImageLayout.Zoom;
            if (NormalImage != null)
                BackgroundImage = NormalImage;
            MouseDown += new MouseEventHandler(_OnMouseDown);
            MouseUp += new MouseEventHandler(_OnMouseUp);
            FlatStyle = FlatStyle.Flat;
            FlatAppearance.BorderSize = 0;
            FlatAppearance.MouseDownBackColor = Color.Transparent;
            FlatAppearance.MouseOverBackColor = Color.Transparent;
            Text = "";
        }

        private void _OnMouseDown(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
            {
                BackgroundImage = _selected ? _SelectedHighlightImage : _NormalHighlightImage;
            }
        }

        private void _OnMouseUp(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
            {
                BackgroundImage = _selected ? _SelectedImage : _NormalImage;
            }
        }

        public bool Selected
        {
            get
            {
                return _selected;
            }
            set
            {
                _selected = value;
                BackgroundImage = _selected ? SelectedImage : NormalImage;
            }
        }

        public Image NormalImage
        {
            get
            {
                return _NormalImage;
            }

            set
            {
                _NormalImage = value;

                _NormalHighlightImage = new Bitmap(_NormalImage);

                // Loop through the images pixels to reset color. 
                for (int x = 0; x < _NormalHighlightImage.Width; x++)
                {
                    for (int y = 0; y < _NormalHighlightImage.Height; y++)
                    {
                        Color pixelColor = _NormalHighlightImage.GetPixel(x, y);
                        Color newColor = Color.FromArgb(pixelColor.A, pixelColor.R * 2 / 3, pixelColor.G * 2 / 3, pixelColor.B * 2 / 3);
                        _NormalHighlightImage.SetPixel(x, y, newColor);
                    }
                }
            }
        }

        public Image SelectedImage
        {
            get
            {
                return _SelectedImage;
            }

            set
            {
                _SelectedImage = value;

                _SelectedHighlightImage = new Bitmap(_SelectedImage);

                // Loop through the images pixels to reset color. 
                for (int x = 0; x < _SelectedHighlightImage.Width; x++)
                {
                    for (int y = 0; y < _SelectedHighlightImage.Height; y++)
                    {
                        Color pixelColor = _SelectedHighlightImage.GetPixel(x, y);
                        Color newColor = Color.FromArgb(pixelColor.A, pixelColor.R * 2 / 3, pixelColor.G * 2 / 3, pixelColor.B * 2 / 3);
                        _SelectedHighlightImage.SetPixel(x, y, newColor);
                    }
                }
            }
        }
    }
}
