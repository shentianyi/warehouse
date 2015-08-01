using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using Brilliantech.Warehouse.LEDServiceHost.Model;
using System.IO.Ports;
using Brilliantech.Warehouse.LEDServiceHost.CusException;
using System.ServiceModel.Web;
using Brilliantech.Warehouse.LEDServiceHost.Helper;

namespace Brilliantech.Warehouse.LEDServiceHost
{
    // 注意: 使用“重构”菜单上的“重命名”命令，可以同时更改代码和配置文件中的类名“Service1”。
    public class LedService : ILedService
    {
        /// <summary>
        /// message 字符串
        /// </summary>
        /// <param name="message"></param>
        /// <returns></returns>
        public  Msg<string> SendTCPMessage(string message)
        {
            WebOperationContext.Current.OutgoingResponse.Headers.Add("Access-Control-Allow-Origin", "*");
            if (WebOperationContext.Current.IncomingRequest.Method == "OPTIONS")
            {
                WebOperationContext.Current.OutgoingResponse.Headers
                    .Add("Access-Control-Allow-Methods", "POST, OPTIONS, GET");
                WebOperationContext.Current.OutgoingResponse.Headers
                    .Add("Access-Control-Allow-Headers",
                         "Content-Type, Accept, Authorization, x-requested-with");
                return null;
            }
            Msg<string> msg = new Msg<string>();
            try
            {
                /// 使用TCPServer向灯节点发送消息
                MainWindow.SendData( StringHelper.GetBytes(message));
                msg.Result = true;
                msg.Content = "PTL-HTTP接收到，并发送到TCPServer";
            }
            catch (Exception e)
            {
                msg.Result = false;
                msg.Content = e.Message;
                if (e.InnerException is SerialPortNotUsableException)
                {
                    msg.Content = e.InnerException.Message;
                }
            }
            return msg;
        }
  

    }
}
