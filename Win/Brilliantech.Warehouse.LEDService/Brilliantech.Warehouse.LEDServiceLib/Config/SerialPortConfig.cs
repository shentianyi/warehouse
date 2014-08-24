using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Brilliantech.Framwork.Utils.ConfigUtil;
using System.IO.Ports;

namespace Brilliantech.Warehouse.LEDServiceLib.Config
{
    public class SerialPortConfig
    {
        private static ConfigUtil config;

        static SerialPortConfig()
        {
            config = new ConfigUtil("Base", @"Ini\serial_port.ini");
            portName = config.Get("PortName");
            portBaudRate = int.Parse(config.Get("BaudRate"));
            portParity = (Parity)int.Parse(config.Get("Parity"));
            dataBits = int.Parse(config.Get("DataBits"));
            portStopBits = (StopBits)int.Parse(config.Get("StopBits"));
            portHandshake = (Handshake)int.Parse(config.Get("Handshake"));
            readTimeout = int.Parse(config.Get("ReadTimeout"));
            writeTimeout = int.Parse(config.Get("WriteTimeout"));
        }
        private static string portName;
        private static int portBaudRate;
        private static Parity portParity;
        private static int dataBits;
        private static StopBits portStopBits;
        private static Handshake portHandshake;
        private static int readTimeout;
        private static int writeTimeout;

        public static string PortName
        {
            get { return SerialPortConfig.portName; }
            set { SerialPortConfig.portName = value; }
        }


        public static int PortBaudRate
        {
            get { return SerialPortConfig.portBaudRate; }
            set { SerialPortConfig.portBaudRate = value; }
        }

        public static Parity PortParity
        {
            get { return SerialPortConfig.portParity; }
            set { SerialPortConfig.portParity = value; }
        }


        public static int DataBits
        {
            get { return SerialPortConfig.dataBits; }
            set { SerialPortConfig.dataBits = value; }
        }


        public static StopBits PortStopBits
        {
            get { return SerialPortConfig.portStopBits; }
            set { SerialPortConfig.portStopBits = value; }
        }


        public static Handshake PortHandshake
        {
            get { return SerialPortConfig.portHandshake; }
            set { SerialPortConfig.portHandshake = value; }
        }

        public static int ReadTimeout
        {
            get { return SerialPortConfig.readTimeout; }
            set { SerialPortConfig.readTimeout = value; }
        }

        public static int WriteTimeout
        {
            get { return SerialPortConfig.writeTimeout; }
            set { SerialPortConfig.writeTimeout = value; }
        }

        public static void Save()
        {
            config.Set("PortName", portName);
            config.Set("BaudRate", portBaudRate);
            config.Set("Parity", (int)portParity);
            config.Set("DataBits", dataBits);
            config.Set("StopBits", (int)portStopBits);
            config.Set("Handshake", (int)portHandshake);
            config.Set("ReadTimeout", readTimeout);
            config.Set("WriteTimeout", writeTimeout);
            config.Save();
        }
    }
}
