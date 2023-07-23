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
    public partial class FeedbackViewControl : BaseViewControl
    {
        public FeedbackViewControl(AppGoViewController ViewController)
        {
            this.ViewController = ViewController;

            InitializeComponent();
        }

        protected override void UpdateUILanguage()
        {
            base.UpdateUILanguage();

            TitleBarControl.Title = LocalizationManager.GetString("feedback");
        }
        
    }
}
