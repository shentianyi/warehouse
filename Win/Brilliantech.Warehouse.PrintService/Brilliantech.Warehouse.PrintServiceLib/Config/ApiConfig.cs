using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Brilliantech.Framwork.Utils.ConfigUtil;
using Brilliantech.Warehouse.PrintServiceLib.Model;

namespace Brilliantech.Warehouse.PrintServiceLib.Config
{
    public class ApiConfig
    {
        private static ConfigUtil config;
        static ApiConfig()
        {
            try
            {
                config = new ConfigUtil("API", "Ini/api.ini");
                Host = config.Get("Host");
                Token = config.Get("Token");
                PrintDataAction = config.Get("PrintDataAction");
            }
            catch (Exception e)
            {
                throw e;
            }
        }
        public static string Host { get; set; }
        public static string Token { get; set; }
        public static string PrintDataAction { get; set; }
    }
}
