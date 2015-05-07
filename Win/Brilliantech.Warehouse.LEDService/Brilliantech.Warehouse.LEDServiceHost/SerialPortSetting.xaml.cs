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
using System.Windows.Shapes;
using System.IO.Ports;
using Brilliantech.Warehouse.LEDServiceLib.Config;

namespace Brilliantech.Warehouse.LEDServiceHost
{
    /// <summary>
    /// SerialPortSetting.xaml 的交互逻辑
    /// </summary>
    public partial class SerialPortSetting : Window
    {
        public SerialPortSetting()
        {
            InitializeComponent();
            LoadDefaultSettings();
        }

        private void LoadDefaultSettings()
        {
            int index = 0;
            // set service port
            ServicePortTB.Text = SerialPortConfig.ServicePort;
            // set zigbee id
            ZigBeeIdTB.Text = SerialPortConfig.ZigBeeId;
            // set port name
            foreach (string s in SerialPort.GetPortNames())
            {
                PortNameCB.Items.Add(s);
                if (s.Equals(SerialPortConfig.PortName)) {
                    PortNameCB.SelectedIndex = index;
                }
                index++;
            } 
            // set baudrate
            BaudRateTB.Text = SerialPortConfig.PortBaudRate.ToString();
            
            // set parity
            index = 0;
            foreach (string s in Enum.GetNames(typeof(Parity)))
            {
                ParityCB.Items.Add(s);
                if (s.Equals(SerialPortConfig.PortParity.ToString()))
                {
                    ParityCB.SelectedIndex = index;
                }
                index++;
            }
            // set databits
            DataBitsTB.Text = SerialPortConfig.DataBits.ToString();

            // set stopbits
            index = 0;
            foreach (string s in Enum.GetNames(typeof(StopBits)))
            {
                StopBitsCB.Items.Add(s);
                if (s.Equals(SerialPortConfig.PortStopBits.ToString()))
                {
                    StopBitsCB.SelectedIndex = index;
                }
                index++;
            }

            // set handshake
            index = 0;
            foreach (string s in Enum.GetNames(typeof(Handshake)))
            {
                HandshakeCB.Items.Add(s);
                if (s.Equals(SerialPortConfig.PortHandshake.ToString()))
                {
                    HandshakeCB.SelectedIndex = index;
                }
                index++;
            }

            // set readtimeout
            ReadTimeoutTB.Text = SerialPortConfig.ReadTimeout.ToString();

            // set writetimeout
            WriteTimeoutTB.Text = SerialPortConfig.WriteTimeout.ToString();
        }

        private void SaveBtn_Click(object sender, RoutedEventArgs e)
        {
            SerialPortConfig.ServicePort = ServicePortTB.Text;
            SerialPortConfig.ZigBeeId = ZigBeeIdTB.Text;
            if (PortNameCB.SelectedIndex != -1)
            {
                SerialPortConfig.PortName = PortNameCB.SelectedItem.ToString();
            }
            SerialPortConfig.PortBaudRate = int.Parse(BaudRateTB.Text);
            SerialPortConfig.PortParity = (Parity)Enum.Parse(typeof(Parity), ParityCB.SelectedItem.ToString(), true);
            SerialPortConfig.DataBits = int.Parse(DataBitsTB.Text);
            SerialPortConfig.PortHandshake = (Handshake)Enum.Parse(typeof(Handshake), HandshakeCB.SelectedItem.ToString(), true);
            SerialPortConfig.PortStopBits = (StopBits)Enum.Parse(typeof(StopBits), StopBitsCB.SelectedItem.ToString(), true);
            SerialPortConfig.ReadTimeout = int.Parse(ReadTimeoutTB.Text);
            SerialPortConfig.WriteTimeout = int.Parse(WriteTimeoutTB.Text);
            SerialPortConfig.Save();

            MessageBox.Show("设置成功，服务将自动重启....");
            System.Diagnostics.Process.Start(Application.ResourceAssembly.Location);
            Application.Current.Shutdown();
           // App.Current.Shutdown();
        }
    }
}
