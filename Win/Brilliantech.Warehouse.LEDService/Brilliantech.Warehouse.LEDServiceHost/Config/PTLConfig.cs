using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Brilliantech.Framwork.Utils.ConfigUtil;
using System.IO.Ports;

namespace Brilliantech.Warehouse.LEDServiceHost.Config
{
    public class PTLConfig
    {
        private static ConfigUtil config;
        private static string ip; 
        private static int port;
        private static string wms_server;
        private static string wms_action;
   


        static PTLConfig()
        {
            config = new ConfigUtil("Base", @"Ini\ptl.ini");
            ip = config.Get("IP");
            port = int.Parse(config.Get("Port"));
            wms_server = config.Get("WMSServer");
            wms_action = config.Get("WMSAction");
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
        public static string WmsServer
        {
            get { return PTLConfig.wms_server; }
            set { PTLConfig.wms_server = value; }
        }

        public static string WmsAction
        {
            get { return PTLConfig.wms_action; }
            set { PTLConfig.wms_action = value; }
        }

        public static void Save()
        {
            config.Set("IP",ip);
            config.Set("Port", port);
            config.Set("WMSServer", wms_server);
            config.Set("WMSAction", wms_action);
            config.Save();
        }
    }
}
