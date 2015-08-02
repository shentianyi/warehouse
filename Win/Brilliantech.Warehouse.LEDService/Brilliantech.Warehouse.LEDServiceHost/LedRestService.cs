using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using RestSharp;
using Brilliantech.Warehouse.LEDServiceHost.Config;
using System.Net;
using System.ServiceModel.Web;
using Brilliantech.Warehouse.LEDServiceHost.Model;
using Brilliantech.Warehouse.LEDServiceHost.Helper;
using Brilliantech.Framwork.Utils.LogUtil;

namespace Brilliantech.Warehouse.LEDServiceHost
{
    public class LedRestService
    {
        string message;
        public LedRestService(string message) {
            this.message = message;
        }

        public Msg<string> Send()
        {
            //if (!setHead())
            //{
            //    return null;
            //}
            Msg<string> msg = new Msg<string>();
            try
            {
                var req = new RestRequest(PTLConfig.WmsAction, Method.POST);
                req.RequestFormat = DataFormat.Json;
                req.AddParameter("message", this.message);

                //  var data = new ApiClient().Execute<RecordSet>(req);
                var res = Execute(req);
                var data = JsonHelper.parse<Msg<String>>(res.Content);
                if (data != null)
                {
                    msg.Result = true;
                    msg.Content = "发送成功";
                }
            }
            catch (Exception e)
            {
                msg.Content = e.Message;
                LogUtil.Logger.Error(e.Message);
            }
            return msg;
        }
        
        public T Execute<T>(IRestRequest request) where T : new()
        {
            var response = genClient().Execute<T>(request);
            return response.Data;
        }

        public IRestResponse Execute(IRestRequest request)
        {
            var response = genClient().Execute(request);
            return responseHandler(response);
        }

        private RestClient genClient()
        {
            var client = new RestClient();
            client.BaseUrl = PTLConfig.WmsServer;
             return client;
        }

        private IRestResponse responseHandler(IRestResponse res)
        {
            if (res.StatusCode != HttpStatusCode.OK)
            {
                WebOperationContext.Current.OutgoingResponse.StatusCode = res.StatusCode;
                WebOperationContext.Current.OutgoingResponse.StatusDescription = res.StatusDescription;
                throw new WebFaultException<string>(res.StatusDescription, res.StatusCode);
            }
            return res;
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
    }
}
