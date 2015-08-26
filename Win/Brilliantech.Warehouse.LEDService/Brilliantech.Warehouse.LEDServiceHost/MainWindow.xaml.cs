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
using Brilliantech.Framwork.Utils.LogUtil; 
using System.ServiceModel;
using Brilliantech.Warehouse.LEDServiceHost.Helper;
using System.Net.Sockets;
using System.Net;
using System.ComponentModel;
using System.Threading;
using System.IO;
using System.Windows.Threading;
using Brilliantech.Warehouse.LEDServiceHost.Config;
//using MessageBox = System.Windows.MessageBox;
//using System.Windows.Forms;

namespace Brilliantech.Warehouse.LEDServiceHost
{
    /// <summary>
    /// MainWindow.xaml 的交互逻辑
    /// </summary>
    public partial class MainWindow : Window
    {
        WebServiceHost host = null;

        string notifyString = "BW PTL TCP Serivce:" + PTLConfig.Address();

       public static bool IsTCPListen = false;
        TcpListener tcpsever = null;
        public event PTCTCPEvent.DataReceivedHandler DataReceived;
         public delegate void UpdateClientListBoxDelegate(bool add_remove,PTLTCPClient client);
        public event UpdateClientListBoxDelegate ClientListUpdated;

        /// <summary>
        /// 当前已连接客户端集合
        /// </summary>
        public static BindingList<PTLTCPClient> TCPClientList = new BindingList<PTLTCPClient>();
    

        public MainWindow()
        {
            InitializeComponent();
            init();
        }
       
        private void init()
        {
            initNotifyIcon();

            startHttpService();
            initTcpServer();
        }
        
        private void startHttpService()
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
                LogUtil.Logger.Info("LED RESTFul服务启动");
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

        private void initTcpServer()
        {
            IPTB.Text = PTLConfig.Ip;
             PortTB.Text = PTLConfig.Port.ToString();
            //IPTB.Text = IPHelper.GetDefaultIPV4();
            this.DataReceived+=new PTCTCPEvent.DataReceivedHandler(TCPClient_DataReceived);
            this.ClientListUpdated+=new UpdateClientListBoxDelegate(BindClientList);
        }

    

        private void SerialPortBtn_Click(object sender, RoutedEventArgs e)
        {
            new SerialPortSetting().ShowDialog();
        }

        private void StartBtn_Click(object sender, RoutedEventArgs e)
        {
            if (IsTCPListen == false)
            {
                // 开始TCPServer
                LogUtil.Logger.Info("LED TCPServer 开始启动");

                StartTCPServer();
            }
            else {
             // 停止TCPServer
                LogUtil.Logger.Info("LED TCPServer 开始停止");
                StopTCPServer();
            }
           IPTB.IsEnabled=PortTB.IsEnabled = !IsTCPListen;
           TCPClientList = new BindingList<PTLTCPClient>();
           TCPClientLB.ItemsSource = null;

           StartBtn.Content = IsTCPListen ? "停 止" : "开 始";
         }

        /// <summary>
        /// 开启TCP监听
        /// </summary>
        /// <returns></returns>
        private void StartTCPServer()
        {
            try
            {
                tcpsever = new TcpListener(IPAddress.Parse(IPTB.Text), int.Parse(PortTB.Text)); 
                LogUtil.Logger.Info("LED TCPServer 启动完成");
                tcpsever.Start();

                tcpsever.BeginAcceptTcpClient(new AsyncCallback(Acceptor), tcpsever);
                IsTCPListen = true;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "错误", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        /// <summary>
        /// 停止TCP监听
        /// </summary>
        /// <returns></returns>
        private void StopTCPServer()
        {

            foreach (PTLTCPClient client in TCPClientList)
            {
                client.DisConnect();
            }
            if (tcpsever != null)
            {
                tcpsever.Stop();
                tcpsever = null;
                IsTCPListen = false;
                LogUtil.Logger.Info("LED TCPServer 停止完成");
            }

        }

        /// <summary>
        /// 停止HTTP监听
        /// </summary>
        private void StopHttpServer() {
            if (host != null) {
                host.Close();
                host = null;
                LogUtil.Logger.Info("LED RESTFul服务停止");
            }
        }


        /// <summary>
        /// 客户端连接初始化
        /// </summary>
        /// <param name="o"></param>
        private void Acceptor(IAsyncResult o)
        {
            TcpListener server = o.AsyncState as TcpListener;
            try
            {
                //初始化连接的客户端
                PTLTCPClient newClient = new PTLTCPClient();
               
                newClient.NetWork = server.EndAcceptTcpClient(o);
              //  tcpClientList.Add(newClient);
              //  BindClientList();

                ClientListUpdated.BeginInvoke(true, newClient, null, null);

                newClient.NetWork.GetStream().BeginRead(newClient.buffer, 0, newClient.buffer.Length, new AsyncCallback(TCPCallBack), newClient);
                server.BeginAcceptTcpClient(new AsyncCallback(Acceptor), server);//继续监听客户端连接
            }
            catch (ObjectDisposedException ex)
            { //监听被关闭
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "错误", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }



        /// <summary>
        /// 客户端通讯回调函数
        /// </summary>
        /// <param name="ar"></param>
        private void TCPCallBack(IAsyncResult ar)
        {
            try
            {
                PTLTCPClient client = (PTLTCPClient)ar.AsyncState;
                if (client.NetWork.Connected)
                {
                    NetworkStream ns = client.NetWork.GetStream();
                    byte[] recdata = new byte[ns.EndRead(ar)];
                    if (recdata.Length > 0)
                    {
                        Array.Copy(client.buffer, recdata, recdata.Length);
                        if (DataReceived != null)
                        {
                            DataReceived.BeginInvoke(client.Name, recdata, null, null);//异步输出数据
                        }
                        ns.BeginRead(client.buffer, 0, client.buffer.Length, new AsyncCallback(TCPCallBack), client);
                    }
                    else
                    {
                        client.DisConnect();
                        ClientListUpdated.BeginInvoke(false, client, null, null);
                    }
                }
            }
            catch (Exception e) {
                LogUtil.Logger.Error(e.Message);
            }
        }
        /// <summary>
        /// 获取TCPClient数据
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="data"></param>
        private void TCPClient_DataReceived(object sender, byte[] data)
        {
            //Thread t = new Thread(new ThreadStart(delegate
            //{

            //    ClientDataTB.Dispatcher.Invoke(new Action(delegate
            //    {
            StreamReader sr = new StreamReader(new MemoryStream(data));
            string message = sr.ReadToEnd();
            //        ClientDataTB.AppendText(message);
            //        ClientDataTB.AppendText("\n");
            //        ClientDataTB.SelectionStart = ClientDataTB.Text.Length;

            LogUtil.Logger.Info("【接到】TCPClient消息: " + message);
            /// 是使用HTTP想WMS服务器(Linux)发送消息
           new LedRestService(message).Send();

            //    }), null);
            //}));

            //t.Start();
        }

        /// <summary>
        /// 绑定客户端列表
        /// </summary>
        private void BindClientList(bool add_remove, PTLTCPClient client)
        {
            TCPClientLB.Dispatcher.Invoke(
                         new Action(() =>
                         {
                             if (add_remove == true)
                             {
                                 LogUtil.Logger.Info("【新的连接】"+client.Name );
                                 TCPClientList.Add(client);
                             }
                             else
                             {
                                 LogUtil.Logger.Info("【断开连接】" + client.Name);
                                 TCPClientList.Remove(client);
                                 client.DisConnect();
                             }

                             TCPClientLB.ItemsSource = null;
                             TCPClientLB.ItemsSource = TCPClientList;
                             TCPClientLB.DisplayMemberPath = "Name";
                         }), null);
        }

        /// <summary>
        /// tcp server send data to all client
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void SendBtn_Click(object sender, RoutedEventArgs e)
        {
          SendData(StringHelper.GetBytes(SendTB.Text.Trim()));
        }

        public static bool SendData(byte[] data)
        {
            foreach (PTLTCPClient client in TCPClientList)
            {
                try
                {
                  string message = StringHelper.GetString(data);

                     LogUtil.Logger.Info("【发送】TCPServer消息: " + message);
                    client.NetWork.GetStream().Write(data, 0, data.Length);
                }
                catch (Exception e)
                {
                    LogUtil.Logger.Error(e.Message);
                    //MessageBox.Show(client.Name + ":" + e.Message, "错误", MessageBoxButton.OK, MessageBoxImage.Error);
                    //return false;
                }
            }
            return true;
        }

        //----------------------------------NOTIFY---------------------------------------------------------
        /// <summary>
        /// 
        /// </summary>
        private System.Windows.Forms.NotifyIcon notifyIcon = null;
        private void initNotifyIcon()
        {
            notifyIcon = new System.Windows.Forms.NotifyIcon();
            notifyIcon.BalloonTipText = notifyString;
            notifyIcon.Text = notifyString;
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
            if (System.Windows.MessageBox.Show("确定要退出吗?",
                                               "退出",
                                                MessageBoxButton.YesNo,
                                                MessageBoxImage.Question,
                                                MessageBoxResult.No) == MessageBoxResult.Yes)
            {
                notifyIcon.Dispose();
                StopTCPServer();
                StopHttpServer();
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

        private void ClearReceiveBtn_Click(object sender, RoutedEventArgs e)
        {
            //ClientDataLB.ItemsSource = null;
            ClientDataTB.Text = "";
        }

    }
}
