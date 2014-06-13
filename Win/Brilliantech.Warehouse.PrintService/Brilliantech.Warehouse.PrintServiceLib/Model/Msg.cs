using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Brilliantech.Warehouse.PrintServiceLib.Model
{
    public class Msg<T>
    {
        public Msg()
        {
            this.Result = true;
        }
    
        public bool Result { get; set; }
        public string Content { get; set; }
        public T Object { get; set; }
    }
}
