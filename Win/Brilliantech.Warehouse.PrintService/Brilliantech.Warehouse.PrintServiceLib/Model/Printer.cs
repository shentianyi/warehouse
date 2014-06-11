using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Brilliantech.Warehouse.PrintServiceLib.Model
{
    public class Printer
    {
        public string Id { get;set; }
        public string Output { get; set; }
        public string Template { get; set; }
        public string Name { get; set; }
        public int Type { get; set; }
        public int Copy { get; set; }
    }
}
