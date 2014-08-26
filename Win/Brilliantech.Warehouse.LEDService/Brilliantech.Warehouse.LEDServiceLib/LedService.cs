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
              //  message = "ff 00 00 00 00 01";
                //List<string> message_in_16 = new List<string>();
                //foreach (string s in message.Split(' ')) {
                //    string v= Convert.ToString(int.Parse(s), 16);
                //    message_in_16.Add(v.Length == 1 ? "0" + v : v);
                //}
                //if (SerialPortHelper.SerialPortCom != null)
                //{
                //    SerialPortHelper.SerialPortCom.WriteLine(String.Join(" ",message_in_16.ToArray()));
                //} 
                //Byte[] m = new Byte[1];
                //m[0] = Byte.Parse(message);
              //  string m =    message;
             //  Byte[] m =new Byte[6]{0xff,0x0,0x0,0x1,0x0,0x1};
                //byte b= m[0];
                //m[0]=Convert.ToByte(message.Split(' ')[0],16);
                //byte c = m[0];
                Byte[] m = new Byte[6];
                int i = 0;
               foreach (string s in message.Split(' ')) {
                 // m[i] = Convert.ToByte(s,16);
                   m[i] =Convert.ToByte( Int32.Parse(s));
                   i++;
               }
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
