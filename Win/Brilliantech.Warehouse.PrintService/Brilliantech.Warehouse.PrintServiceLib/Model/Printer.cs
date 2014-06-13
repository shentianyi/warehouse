using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Brilliantech.ReportGenConnector;
using TECIT.TFORMer;
using System.IO;

namespace Brilliantech.Warehouse.PrintServiceLib.Model
{
    public class Printer
    {
        public string Id { get; set; }
        public string Output { get; set; }
        public string Template { get; set; }
        public string TemplatePath
        {
            get
            {
                return Path.Combine(AppDomain.CurrentDomain.BaseDirectory,"Template", this.Template);
            }
        }
        public string Name { get; set; }
        public int Type { get; set; }
        public int Copy { get; set; }
        public void Print(RecordSet data)
        {
            IReportGen gen = new TecITGener();
            ReportGenConfig config = new ReportGenConfig()
            {
                Printer = this.Name,
                NumberOfCopies = this.Copy,
                PrinterType = (PrinterType)this.Type,
                Template = this.TemplatePath
            };
            gen.Print(data, config);
        }
    }
}
