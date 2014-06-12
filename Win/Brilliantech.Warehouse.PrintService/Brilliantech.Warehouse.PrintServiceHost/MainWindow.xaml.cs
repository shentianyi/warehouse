using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Net.Sockets;
using System.Net;
using System.ServiceModel.Web;
using Brilliantech.Warehouse.PrintServiceLib;

namespace Brilliantech.Warehouse.PrintServiceHost
{
    /// <summary>
    /// MainWindow.xaml 的交互逻辑
    /// </summary>
    public partial class MainWindow : Window
    {
        WebServiceHost host = null;

        public MainWindow()
        {
            InitializeComponent();
            init();
        }
        private void init()
        {
            //IPLab.Content = getLoalIP();
            startService();
        }

        private void startService() {
            try
            {
                if (host == null)
                {
                    host = new WebServiceHost(typeof(PrintService));
                }
                host.Open(); 
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        // get local ip
        private string getLoalIP()
        {
            return Dns.GetHostEntry(Dns.GetHostName()).AddressList.FirstOrDefault(ip => ip.AddressFamily == AddressFamily.InterNetwork).ToString();
        }

        private void SetPrinterBtn_Click(object sender, RoutedEventArgs e)
        {
            new PrinterSetting().ShowDialog();
        }
    }
}
