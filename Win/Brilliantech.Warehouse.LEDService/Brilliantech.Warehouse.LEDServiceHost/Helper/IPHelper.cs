using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Management;  
using System.Net;
using System.Net.Sockets;

namespace Brilliantech.Warehouse.LEDServiceHost.Helper
{
    public class IPHelper
    {
        public static string GetDefaultIPV4()
        {
            //ManagementClass mcNetworkAdapterConfig = new ManagementClass("Win32_NetworkAdapterConfiguration");
            //ManagementObjectCollection moc_NetworkAdapterConfig = mcNetworkAdapterConfig.GetInstances();

            //foreach (ManagementObject mo in moc_NetworkAdapterConfig)
            //{
            //    string mServiceName = mo["ServiceName"] as string;
            //}
            //IPAddress[] ips = Dns.GetHostAddresses(Dns.GetHostName());

            IPHostEntry ipHostEntry = Dns.GetHostEntry(Dns.GetHostName());
            IPAddress ip = ipHostEntry.AddressList.FirstOrDefault(i => i.AddressFamily.Equals(AddressFamily.InterNetwork));

            return ip.ToString();
            //foreach (IPAddress ip in ipHostEntry.AddressList)
            //{
            //    if (ip.AddressFamily == System.Net.Sockets.AddressFamily.InterNetwork)
            //    { 

            //    }
            //}
        }
    }
}
