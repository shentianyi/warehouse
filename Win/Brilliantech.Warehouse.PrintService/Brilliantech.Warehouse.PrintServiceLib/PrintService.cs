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

namespace Brilliantech.Warehouse.PrintServiceLib
{
    // 注意: 使用“重构”菜单上的“重命名”命令，可以同时更改代码和配置文件中的类名“Service1”。
    public class PrintService : IPrintService
    {
        public string Print(string code,string id)
        {
            try
            {
                var req = new RestRequest(ApiConfig.PrintDataAction, Method.POST);
                req.RequestFormat = DataFormat.Json;
                req.AddParameter("code", code);
                req.AddParameter("id", id);
                var response = new ApiClient().Execute(req);
                return string.Format("You entered: {0}-{1}", code, id);
            }
            catch (Exception e) {
                return null;
            }
        }
    }
}
