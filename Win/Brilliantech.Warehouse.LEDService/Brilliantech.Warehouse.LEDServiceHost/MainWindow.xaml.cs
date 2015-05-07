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
using System.ServiceModel.Web;
using Brilliantech.Warehouse.LEDServiceLib;
using Brilliantech.Framwork.Utils.LogUtil;
using Brilliantech.Warehouse.LEDServiceLib.Config;
using System.ServiceModel;

namespace Brilliantech.Warehouse.LEDServiceHost
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
            initNotifyIcon();
            startService(); 
        }
        private void startService()
        {
            try
            {
                Uri u = new Uri("http://localhost:" + SerialPortConfig.ServicePort + "/led");
                Uri[] baseAddresses = { new Uri("http://localhost:" + SerialPortConfig.ServicePort + "/led") };
                if (host == null)
                {
                    host = new WebServiceHost(typeof(LedService), baseAddresses);
                }
                host.Open();
                LogUtil.Logger.Info("LED服务启动");
            }
            catch (AddressAlreadyInUseException e)
            {
                LogUtil.Logger.Error(e.Message);
                MessageBox.Show("端口" + SerialPortConfig.ServicePort + "被占用，请重新配置后重启本程序", "错误", MessageBoxButton.OK, MessageBoxImage.Error);
            }
            catch (Exception e)
            {
                MessageBox.Show(e.Message);
                LogUtil.Logger.Error(e.Message);
            }
        }
        private System.Windows.Forms.NotifyIcon notifyIcon = null;
        private void initNotifyIcon()
        {
            ZigBeeIdLab.Content = SerialPortConfig.ZigBeeId;
            ServicePortLab.Content = SerialPortConfig.ServicePort;

            notifyIcon = new System.Windows.Forms.NotifyIcon();
            notifyIcon.BalloonTipText = "BW LED " + SerialPortConfig.ZigBeeId + "(" + SerialPortConfig.ServicePort + ") Serivce";
            notifyIcon.Text = "BW LED " + SerialPortConfig.ZigBeeId + "(" + SerialPortConfig.ServicePort + ") LED Serivce";
            string path = System.IO.Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "i.ico");
            notifyIcon.Icon = new System.Drawing.Icon(path);
            notifyIcon.Visible = true;
            notifyIcon.ShowBalloonTip(2000);
            notifyIcon.MouseClick += new System.Windows.Forms.MouseEventHandler(notifyIcon_MouseClick);

            System.Windows.Forms.MenuItem item1 = new System.Windows.Forms.MenuItem("Menu 1");


            System.Windows.Forms.MenuItem exit = new System.Windows.Forms.MenuItem("退出");

            exit.Click += new EventHandler(exit_Click);

            System.Windows.Forms.MenuItem[] menus = new System.Windows.Forms.MenuItem[] { exit };
            notifyIcon.ContextMenu = new System.Windows.Forms.ContextMenu(menus);
            this.StateChanged += new EventHandler(MainWindow_StateChanged);
        }

        private void MainWindow_StateChanged(object sender, EventArgs e)
        {
            if (this.WindowState == WindowState.Minimized)
            {
                this.Visibility = Visibility.Hidden;
            }
        }

        private void exit_Click(object sender, EventArgs e)
        {
            if (System.Windows.MessageBox.Show("确定要退出"+SerialPortConfig.ZigBeeId+"("+SerialPortConfig.ServicePort+")吗?",
                                               "退出",
                                               MessageBoxButton.YesNo,
                                                MessageBoxImage.Question,
                                                MessageBoxResult.No) == MessageBoxResult.Yes)
            {
                notifyIcon.Dispose();
                System.Windows.Application.Current.Shutdown();
            }
        }

        private void notifyIcon_MouseClick(object sender, System.Windows.Forms.MouseEventArgs e)
        {
            if (e.Button == System.Windows.Forms.MouseButtons.Left)
            {
                if (this.Visibility == Visibility.Visible)
                {
                    this.Visibility = Visibility.Hidden;
                }
                else
                {
                    this.Visibility = Visibility.Visible;
                    this.Activate();
                    this.WindowState = WindowState.Normal;
                }
            }
        }

        private void Window_Closing(object sender, System.ComponentModel.CancelEventArgs e)
        {
            this.Visibility = Visibility.Hidden;
            e.Cancel = true;
        }

        private void SerialPortBtn_Click(object sender, RoutedEventArgs e)
        {
            new SerialPortSetting().ShowDialog();
        }
    }
}
