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

            SerialPort serialPort;
            // Create port
            serialPort = new SerialPort();

            // Set the appropriate properties.
            serialPort.PortName = "COM1";
            //TODO: Read these settings from configuration file
            serialPort.BaudRate = 9600;
            serialPort.Parity = Parity.None;
            serialPort.DataBits = 8;
            serialPort.StopBits = StopBits.One;
            serialPort.Handshake = Handshake.None;

            // Set the read/write timeouts
            serialPort.ReadTimeout = 500;
            serialPort.WriteTimeout = 500;
            serialPort.Open();
            serialPort.WriteLine("aaaa");
            serialPort.Close();
            Console.Read();
        }
    }
}
