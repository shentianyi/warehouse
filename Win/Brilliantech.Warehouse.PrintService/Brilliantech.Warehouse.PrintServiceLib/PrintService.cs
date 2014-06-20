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

namespace Brilliantech.Warehouse.PrintServiceLib
{
    // 注意: 使用“重构”菜单上的“重命名”命令，可以同时更改代码和配置文件中的类名“Service1”。
    public class PrintService : IPrintService
    {
        public Msg<string> Print(string code, string id)
        {
            Msg<string> msg = new Msg<string>();
            try
            {
                var req = new RestRequest(ApiConfig.PrintDataAction, Method.GET);
                req.RequestFormat = DataFormat.Json;
                req.AddParameter("code", code);
                req.AddParameter("id", id);
                Printer printer = PrinterConfig.Find(code);

              //  var data = new ApiClient().Execute<RecordSet>(req);
                var res = new ApiClient().Execute(req);
                var data = parse<RecordSet>(res.Content);
                if (data != null && data.Count > 0)
                {
                    printer.Print(data);
                    msg.SetTrue();
                    msg.Content = "打印成功";
                }
                else {
                    msg.Content = "打印失败,无打印内容";
                }
            }
            catch (Exception e) {
                msg.Content = e.Message;
                LogUtil.Logger.Error(e.Message);
            } 
            return msg;
        }

        public  T parse<T>(string jsonString)
        {
            using (var ms = new MemoryStream(Encoding.UTF8.GetBytes(jsonString)))
            {
                return (T)new DataContractJsonSerializer(typeof(T)).ReadObject(ms);
            }
        }
    }
}
