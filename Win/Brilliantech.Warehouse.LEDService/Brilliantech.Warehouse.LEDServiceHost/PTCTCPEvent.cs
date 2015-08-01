using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Brilliantech.Warehouse.LEDServiceHost
{
    public class PTCTCPEvent
    { /// <summary>
        /// 数据接收事件
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="data"></param>
        public delegate void DataReceivedHandler(object sender, byte[] data);

        /// <summary>
        /// 发送数据事件
        /// </summary>
        /// <param name="data"></param>
        public delegate bool DataSendHandler(byte[] data);
    }
}
