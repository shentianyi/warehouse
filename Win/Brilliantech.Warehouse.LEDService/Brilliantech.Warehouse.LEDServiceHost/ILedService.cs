using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ServiceModel;
using System.ServiceModel.Web;
using Brilliantech.Warehouse.LEDServiceHost.Model;

namespace Brilliantech.Warehouse.LEDServiceHost
{
    [ServiceContract]
    public interface ILedService
    {
        [OperationContract]
        [WebInvoke(Method = "POST", ResponseFormat = WebMessageFormat.Json, UriTemplate = "ptl/send/{message}")]
        Msg<string> SendComMessage(string message);
    }
}
