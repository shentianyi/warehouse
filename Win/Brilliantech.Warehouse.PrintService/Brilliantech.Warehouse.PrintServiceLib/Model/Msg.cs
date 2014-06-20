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
            this.Result = false;
            this.Code = 0;
        }
    
        public bool Result { get; set; }
        public int Code{get;set;}
        public string Content { get; set; }
        public T Object { get; set; }

        public void SetTrue() {
            this.Result = true;
            this.Code = 1;
        }
    }
}
