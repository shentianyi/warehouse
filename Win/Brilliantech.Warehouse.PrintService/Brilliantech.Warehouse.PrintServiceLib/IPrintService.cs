using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using System.ServiceModel.Web;
using Brilliantech.Warehouse.PrintServiceLib.Model;

namespace Brilliantech.Warehouse.PrintServiceLib
{
    // 注意: 使用“重构”菜单上的“重命名”命令，可以同时更改代码和配置文件中的接口名“IService1”。
    [ServiceContract]
    public interface IPrintService
    {
        /// <summary>
        /// print action
        /// </summary>
        /// <param name="code">print output code</param>
        /// <param name="id">id for print</param>
        /// <returns></returns>
        [WebInvoke(Method = "GET", ResponseFormat = WebMessageFormat.Json, UriTemplate = "print/{code}/{id}")]
        Msg<string> Print(string code, string id); 
    }  
}
