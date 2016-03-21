using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using System.Data;
using Brilliantech.ReportGenConnector;

namespace Brilliantech.Warehouse.PrintServiceLib.Model
{
    [DataContract]
    public class PrintData
    {
        [DataMember]
        public string code { get; set; }
        [DataMember]
        public RecordSet data_set { get; set; }
    }
}
