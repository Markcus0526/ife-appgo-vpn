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

namespace AppGo.View
{
    public class BaseViewControl : UserControl
    {
        private AppGoViewController _ViewController;

        public AppGoViewController ViewController
        {
            get
            {
                return _ViewController;
            }
            set
            {
                _ViewController = value;
                _ViewController.Controller.UserLanguageChanged += new EventHandler(Controller_UserLanguageChanged);
            }
        }

        public BaseViewControl()
        {
            Load += new EventHandler(_OnLoad);
        }

        private void _OnLoad(object sender, EventArgs e)
        {
            UpdateUILanguage();
        }


        protected override void WndProc(ref Message m)
        {
            const int WM_SYSCOMMAND = 0x112;
            const int WM_NCHITTEST = 0x84;
            const int HTCLIENT = 1;
            const int HTTRANSPARENT = -1;

            switch (m.Msg)
            {
                case WM_NCHITTEST:
                    {
                        base.WndProc(ref m);

                        if (m.Result.ToInt32() == HTCLIENT)
                        {
                            // Make the rest of the form's entire client area draggable
                            // by having it report itself as part of the caption region.
                            m.Result = new IntPtr(HTTRANSPARENT);
                        }
                        
                        return;
                    }

                case WM_SYSCOMMAND:
                    {
                        // Setting the form's MaximizeBox property to false does *not* disable maximization
                        // behavior when the caption area is double-clicked.
                        // Since this window is fixed-size and does not support a "maximized" mode, and the
                        // entire client area is treated as part of the caption to enable dragging, we also
                        // need to ensure that double-click-to-maximize is disabled.
                        // NOTE: See documentation for WM_SYSCOMMAND for explanation of the magic value 0xFFF0!
                        const int SC_MAXIMIZE = 0xF030;
                        if ((m.WParam.ToInt32() & 0xFFF0) == SC_MAXIMIZE)
                        {
                            m.Result = IntPtr.Zero;
                        }
                        else
                        {
                            base.WndProc(ref m);
                        }
                        return;
                    }
            }
            base.WndProc(ref m);
        }

        private void InitializeComponent()
        {
            this.SuspendLayout();
            // 
            // BaseViewControl
            // 
            this.BackColor = System.Drawing.Color.Transparent;
            this.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.Name = "BaseViewControl";
            this.Size = new System.Drawing.Size(380, 570);
            this.ResumeLayout(false);

        }

        protected void Controller_UserLanguageChanged(object sender, EventArgs e)
        {
            UpdateUILanguage();
        }

        protected virtual void UpdateUILanguage()
        {
            return;
        }        
    }
}
