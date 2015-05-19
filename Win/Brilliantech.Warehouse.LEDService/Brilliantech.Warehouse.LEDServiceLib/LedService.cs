using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using Brilliantech.Warehouse.LEDServiceLib.Model;
using System.IO.Ports;
using Brilliantech.Warehouse.LEDServiceLib.CusException;
using System.ServiceModel.Web;

namespace Brilliantech.Warehouse.LEDServiceLib
{
    // 注意: 使用“重构”菜单上的“重命名”命令，可以同时更改代码和配置文件中的类名“Service1”。
    public class LedService : ILedService
    {
        /// <summary>
        /// message 是十六进制如：ff 64 32 01 10
        /// 255 100 50 1 16
        /// </summary>
        /// <param name="message"></param>
        /// <returns></returns>
        public Model.Msg<string> SendComMessage(string message)
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
                 //message = "255 0 255 4 274";
                
                Byte[] m = new Byte[6];
                string[] ms = message.Split(' ');
                // RGB & Rate 4 Byte
                for (int i = 0; i < 4; i++)
                {
                    //  m[i] = Convert.ToByte(string.Format("{0:X2}",int.Parse( ms[i])));
                    m[i] = Convert.ToByte(Int32.Parse(ms[i]));
                }
                string ledId = string.Format("{0:X4}",int.Parse( ms[4]));
                // LED ID
                m[4] =Convert.ToByte( Convert.ToInt32(ledId.Substring(0, 2),16));
                m[5] = Convert.ToByte(Convert.ToInt32(ledId.Substring(2, 2), 16));
                
                if (SerialPortHelper.SerialPortCom != null)
                {
                    SerialPortHelper.SerialPortCom.Write(m,0,6);
                }
                msg.Result = true;
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
