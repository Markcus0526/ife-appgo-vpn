using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Drawing;
using AppGo.Controller;
using System.ComponentModel;

namespace AppGo.View.CustomControls
{
    class AGPlaceholderTextBox : TextBox
    {
        public Placeholder placeholder;

        private bool IsPasswordMode = false;
        private bool IsInPasswordMode = false;
        private char _PaswordChar = '\0';

        public AGPlaceholderTextBox()
        {
            placeholder = new Placeholder(this);

            _PaswordChar = new TextBox { UseSystemPasswordChar = true }.PasswordChar;
            this.AutoSize = false;

            if (string.IsNullOrEmpty(Text))
                placeholder.Active = true;

            GotFocus += new EventHandler(_GotFocus);
            LostFocus += new EventHandler(_LostFocus);
            TextChanged += new EventHandler(_TextChanged);
        }

        private void _GotFocus(object sender, EventArgs e)
        {
            placeholder.Active = false;
        }

        private void _LostFocus(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(Text))
                placeholder.Active = true;
        }

        public void SetUseSystemPasswordChar(bool _UseSystemPasswordChar)
        {
            IsPasswordMode = _UseSystemPasswordChar;
        }

        private void _TextChanged(object sender, EventArgs e)
        {
            if (IsPasswordMode)
            {
                if (!IsInPasswordMode && !string.IsNullOrEmpty(Text) && !placeholder.Active)
                {
                    IsInPasswordMode = true;
                    PasswordChar = _PaswordChar;
                }
                else if (IsInPasswordMode && string.IsNullOrEmpty(Text))
                {
                    IsInPasswordMode = false;
                    PasswordChar = '\0';
                }
            }
        }

        public override string Text
        {
            get
            {
                if (placeholder.Active)
                    return "";

                return base.Text;
            }

            set
            {
                base.Text = value;
            }
        }

        [DefaultValue(false)]
        [Browsable(true)]
        public override bool AutoSize
        {
            get
            {
                return base.AutoSize;
            }
            set
            {
                base.AutoSize = value;
            }
        }
    }

    class Placeholder
    {
        private AGPlaceholderTextBox textBox;
        private bool active = false;

        public Placeholder(AGPlaceholderTextBox textBox)
        {
            this.textBox = textBox;
        }
        public bool Active
        {
            get { return active; }
            set
            {
                bool currentActive = active;

                active = value;

                if (value)
                {
                    textBox.ForeColor = ForeColor;
                    textBox.Text = Text;
                }
                else if (currentActive && !value)
                {
                    textBox.ForeColor = previousForeColor;
                    textBox.Text = string.Empty;
                }
            }
        }
        private Color previousForeColor;
        private Color foreColor = Color.FromArgb(170, 170, 170);
        public Color ForeColor
        {
            get { return foreColor; }
            set
            {
                previousForeColor = ForeColor;
                ForeColor = value;
            }
        }
        private string text = "";
        public string Text
        {
            get { return text; }
            set
            {
                text = value;

                if (active)
                {
                    textBox.Text = Text;
                    Active = true;
                }
            }
        }
    }
}
