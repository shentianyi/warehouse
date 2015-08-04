using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO.Ports;
using Brilliantech.Framwork.Utils.LogUtil;
using Brilliantech.Warehouse.LEDServiceHost.CusException;
using Brilliantech.Warehouse.LEDServiceHost.Config;

namespace Brilliantech.Warehouse.LEDServiceHost.Helper
{
    public class SerialPortHelper
    {
        public static SerialPort serialPortCom;

        static SerialPortHelper()
        {
            initPort();
        }


        public static SerialPort SerialPortCom
        {
            get
            {
                return SerialPortHelper.serialPortCom;
            }
        }

        private static void initPort()
        {
            try
            {
                serialPortCom = new SerialPort();
                serialPortCom.PortName = SerialPortConfig.PortName;
                serialPortCom.BaudRate = SerialPortConfig.PortBaudRate;
                serialPortCom.Parity = SerialPortConfig.PortParity;
                serialPortCom.DataBits = SerialPortConfig.DataBits;
                serialPortCom.StopBits = SerialPortConfig.PortStopBits;
                serialPortCom.Handshake = SerialPortConfig.PortHandshake;
                // time out set
                serialPortCom.ReadTimeout = SerialPortConfig.ReadTimeout;
                serialPortCom.WriteTimeout = SerialPortConfig.WriteTimeout;
                serialPortCom.Open();
            }
            catch (Exception e)
            {
                throw new SerialPortNotUsableException(e.Message + "\n 串口不存在或串口已被占用");
            }
        }
    }
}
