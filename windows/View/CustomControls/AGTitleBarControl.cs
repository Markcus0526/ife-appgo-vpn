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

namespace AppGo.View.CustomControls
{
    public partial class AGTitleBarControl : UserControl
    {
        private EventHandler BackButtonClickedEventHandler = null;
        private BaseViewControl View;

        public AGTitleBarControl()
        {
            InitializeComponent();
        }

        private void BackButton_Click(object sender, EventArgs e)
        {
            if (BackButtonClickedEventHandler == null)
            {
                if (View == null)
                {
                    if (Parent is BaseViewControl)
                        View = (BaseViewControl)Parent;
                    else
                        return;
                }
                View.ViewController.PopBackToPreviousView();
            }
            else
            {
                BackButtonClickedEventHandler.Invoke(sender, e);
            }
        }

        public string Title
        {
            get
            {
                 return TitleLabel.Text;
            }
            set
            {
                TitleLabel.Text = value;
            }
        }

        public void SetBackButtonClickedEventHandler(EventHandler BackButtonClickedEventHandler)
        {
            this.BackButtonClickedEventHandler = BackButtonClickedEventHandler;
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
    }
}
