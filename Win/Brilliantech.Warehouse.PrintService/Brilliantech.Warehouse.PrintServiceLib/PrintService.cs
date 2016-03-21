using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using System.ServiceModel.Web;
using RestSharp;
using Brilliantech.Warehouse.PrintServiceLib.Config;
using Brilliantech.Warehouse.PrintServiceLib.Model;
using System.Net;
using Brilliantech.Warehouse.PrintServiceHost.Config;
using Brilliantech.ReportGenConnector;
using System.IO;
using System.Runtime.Serialization.Json;
using Brilliantech.Framwork.Utils.LogUtil;
using Newtonsoft.Json;
using System.Drawing.Printing;

namespace Brilliantech.Warehouse.PrintServiceLib
{
    // 注意: 使用“重构”菜单上的“重命名”命令，可以同时更改代码和配置文件中的类名“Service1”。
    public class PrintService : IPrintService
    {
        public Msg<string> Print(string code, string id)
        {
            return basePrint(code, id);
        }
        
        public Msg<string> Print(string code, string id, string printer_name)
        {
            return basePrint(code, id, printer_name);
        }

        public Msg<string> Print(string code, string id, string printer_name, string copy)
        {
            return basePrint(code, id, printer_name, copy);
        }


        public Msg<string> CrossPrint(string code, string id)
        {
            return basePrint(code, id);
        }


        public Msg<PrintSet> Printers()
        {
            
            Msg<PrintSet> msg = new Msg<PrintSet>();
            try
            {
                PrintSet ps=new PrintSet(){ DefaultPrinters=PrinterConfig.Printers,SystemPrinters=PrinterConfig.SystemPrinters};
                msg.Result = true;
                msg.Object = ps;
            }
            catch (Exception e)
            {
                msg.Content = e.Message;
                LogUtil.Logger.Error(e.Message);
            }
            return msg;
        }

        private Msg<string> basePrint(string code, string id, string printer_name = null, string copy = null)
        {
            if (!setHead())
            {
                return null;
            }
            Msg<string> msg = new Msg<string>();
            try
            {
                var req = new RestRequest(ApiConfig.PrintDataAction, Method.GET);
                req.RequestFormat = DataFormat.Json;
                req.AddParameter("code", code);
                req.AddParameter("id", id);
                
                //  var data = new ApiClient().Execute<RecordSet>(req);
                var res = new ApiClient().Execute(req);
                var data = parse<PrintData>(res.Content);
                if (data != null && data.data_set.Count > 0)
                {
                    Printer printer = PrinterConfig.Find(data.code);
                    printer.Print(data.data_set,printer_name,copy);
                    msg.Result = true;
                    msg.Content = "打印成功";
                }
                else
                {
                    msg.Content = "打印失败,无打印内容";
                }
            }
            catch (Exception e)
            {
                msg.Content = e.Message;
                LogUtil.Logger.Error(e.Message);
            }
            return msg;
        }
        private bool setHead()
        {
            WebOperationContext.Current.OutgoingResponse.Headers.Add("Access-Control-Allow-Origin", "*");
            if (WebOperationContext.Current.IncomingRequest.Method == "OPTIONS")
            {
                WebOperationContext.Current.OutgoingResponse.Headers
                    .Add("Access-Control-Allow-Methods", "POST, OPTIONS, GET");
                WebOperationContext.Current.OutgoingResponse.Headers
                    .Add("Access-Control-Allow-Headers",
                         "Content-Type, Accept, Authorization, x-requested-with");
                return false;
            }
            return true;
        }

        public T parse<T>(string jsonString)
        {
            using (var ms = new MemoryStream(Encoding.UTF8.GetBytes(jsonString)))
            {
                return (T)new DataContractJsonSerializer(typeof(T)).ReadObject(ms);
            }
        }

        public static string stringify(object jsonObject)
        {
            using (var ms = new MemoryStream())
            {
                new DataContractJsonSerializer(jsonObject.GetType()).WriteObject(ms, jsonObject);
                return Encoding.UTF8.GetString(ms.ToArray());
            }
        }
    }
}
