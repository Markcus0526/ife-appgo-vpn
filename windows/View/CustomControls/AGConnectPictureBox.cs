using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;
using AppGo.Properties;
using System.Diagnostics;

namespace AppGo.View.CustomControls
{
    public class AGConnectPictureBox : PictureBox
    {
        private static Mutex mut = new Mutex();

        public bool IsOnAnimation = false;

        private bool IsConnected = false;

        private List<Image> ConnectImageList;

        public AGConnectPictureBox()
        {
            //BackColor = Color.FromArgb(88, 199, 255);
            BackgroundImageLayout = ImageLayout.Zoom;
            
            SetConnected(IsConnected);

            ConnectImageList = new List<Image>();
            ConnectImageList.Add(Resources.ic_connecting01);
            ConnectImageList.Add(Resources.ic_connecting02);
            ConnectImageList.Add(Resources.ic_connecting03);
            ConnectImageList.Add(Resources.ic_connecting04);
            ConnectImageList.Add(Resources.ic_connecting05);
            ConnectImageList.Add(Resources.ic_connecting06);
            ConnectImageList.Add(Resources.ic_connecting07);
            ConnectImageList.Add(Resources.ic_connecting08);
            ConnectImageList.Add(Resources.ic_connecting09);
            ConnectImageList.Add(Resources.ic_connecting10);
            ConnectImageList.Add(Resources.ic_connecting11);
            ConnectImageList.Add(Resources.ic_connecting12);
            ConnectImageList.Add(Resources.ic_connecting13);
            ConnectImageList.Add(Resources.ic_connecting14);
            ConnectImageList.Add(Resources.ic_connecting15);
            ConnectImageList.Add(Resources.ic_connecting16);
            ConnectImageList.Add(Resources.ic_connecting17);
            ConnectImageList.Add(Resources.ic_connecting18);            
        }

        public override string Text
        {
            get
            {
                return base.Text;
            }

            set
            {
                base.Text = "";
            }
        }

        public async void StartAnimation()
        {
            IsOnAnimation = true;

            int nIndex = 0;
            while (IsOnAnimation)
            {
                mut.WaitOne();

                Image = ConnectImageList[nIndex];

                mut.ReleaseMutex();

                await Task.Delay(70); //wait for one second after changing

                nIndex++;
                if (nIndex >= ConnectImageList.Count)
                    nIndex = 0;
            }
        }

        public void StopAnimation()
        {
            IsOnAnimation = false;
        }

        public void SetConnected(bool connected)
        {
            StopAnimation();

            mut.WaitOne();

            IsConnected = connected;
            Image = connected ? Resources.ic_connected : Resources.ic_disconnected;

            mut.ReleaseMutex();
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
                            Point pos = this.PointToClient(Cursor.Position);                            
                            if (pos.X > this.Size.Width * 0.3 && pos.X < this.Size.Width * 0.7 &&
                                pos.Y > this.Size.Width * 0.3 && pos.Y < this.Size.Width * 0.7)
                            {                                
                            }
                            else
                            {
                                // Make the rest of the form's entire client area draggable
                                // by having it report itself as part of the caption region.
                                m.Result = new IntPtr(HTTRANSPARENT);
                            }                            
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
