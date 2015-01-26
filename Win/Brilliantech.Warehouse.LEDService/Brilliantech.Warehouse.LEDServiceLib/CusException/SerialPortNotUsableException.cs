using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Brilliantech.Warehouse.LEDServiceLib.CusException
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
