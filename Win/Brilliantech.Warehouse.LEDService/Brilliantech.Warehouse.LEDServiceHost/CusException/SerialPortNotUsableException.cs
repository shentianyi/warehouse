using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Brilliantech.Warehouse.LEDServiceHost.CusException
{
    public class SerialPortNotUsableException : Exception
    {
        public SerialPortNotUsableException()
        {

        }



        public SerialPortNotUsableException(string message)
            : base(message)
        {

        }
    }
}
