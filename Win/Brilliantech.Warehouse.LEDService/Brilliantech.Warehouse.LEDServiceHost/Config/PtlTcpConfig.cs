using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Brilliantech.Framwork.Utils.ConfigUtil;
using System.IO.Ports;

namespace Brilliantech.Warehouse.LEDServiceHost.Config
{
    public class PtlTcpConfig
    {
        private static ConfigUtil config;
        private static string ip;
        private static int port;


        static PtlTcpConfig()
        {
            config = new ConfigUtil("Base", @"Ini\ptl_tcp.ini");
            ip = config.Get("IP");
            port = int.Parse(config.Get("Port"));
        }


        public static string Ip
        {
            get { return ip; }
            set { ip = value; }
        }

        public static int Port
        {
            get { return port; }
            set { port=value; }
        }

        public static string Address() {
            return String.Format("{0}:{1}", ip, port);
        }

        public static void Save()
        {
            config.Set("IP",ip);
            config.Set("Port", port);
            config.Save();
        }
    }
}
