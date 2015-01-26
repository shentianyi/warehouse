using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO.Ports;

namespace Brilliantech.Warehouse.LEDService.ConsoleApp
{
    class Program
    {
        static void Main(string[] args)
        {

            //SerialPort serialPort;
            //// Create port
            //serialPort = new SerialPort();

            //// Set the appropriate properties.
            //serialPort.PortName = "COM1";
            ////TODO: Read these settings from configuration file
            //serialPort.BaudRate = 9600;
            //serialPort.Parity = Parity.None;
            //serialPort.DataBits = 8;
            //serialPort.StopBits = StopBits.One;
            //serialPort.Handshake = Handshake.None;

            //// Set the read/write timeouts
            //serialPort.ReadTimeout = 500;
            //serialPort.WriteTimeout = 500;
            //serialPort.Open();
            //serialPort.WriteLine("aaaa");
            //serialPort.Close();
            //Console.WriteLine(Int32.Parse("247"));
            //int num = 255;
            //Console.WriteLine(string.Format("{0:X2}", num));
          //  Console.WriteLine(Convert.ToByte(Int32.Parse("255")));
            string message = "255 0 0 0 274";
            //string[] s = message.Split(' ');
            //Console.WriteLine(Convert.ToInt32("FF", 16));
            //message = "255 0 0 0 1";

            Byte[] m = new Byte[6];
            string[] ms = message.Split(' ');
            // RGB & Rate 4 Byte
            for (int i = 0; i < 4; i++)
            {
                //  m[i] = Convert.ToByte(string.Format("{0:X2}",int.Parse( ms[i])));
                m[i] = Convert.ToByte(Int32.Parse(ms[i]));
            }
            string ledId = string.Format("{0:X4}", int.Parse(ms[4]));
            // LED ID
            m[4] = Convert.ToByte(Convert.ToInt32(ledId.Substring(0, 2), 16));
            m[5] = Convert.ToByte(Convert.ToInt32(ledId.Substring(2, 2), 16));
            Console.WriteLine(m);
            Console.Read();
        }
    }
}
