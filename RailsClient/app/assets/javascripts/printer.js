var printer={
           url:function(code,id){
               return $('#print-server-hidden').val()+code+'/'+id;
           },
           print:function(code,id){
               var url=this.url(code,id);
               show_handle_dialog();
               $.ajax({
                   url: url,
                   type: 'get',
                   dataType: 'json',
                   async: false,
                   timeout: 10000,
                   crossDomain: true,
                   success: function (data) {
                       if (data) {
                           alert(data.Content);
                       } else {
                           alert('打印失败，请开启打印服务器或重新配置');
                       }
                   },
                   error: function (XMLHttpRequest, textStatus, errorThrown) {
                       console.log(XMLHttpRequest.status);
                       if (XMLHttpRequest.status == 500) {
                           alert('打印打印服务程序内部错误，请联系系统管理员或服务商');
                       } else {
                           alert('无法连接打印服务器，请开启打印服务器或重新配置 或 打印被取消');
                       }
                   }
               }).always(function () {
                       hide_handle_dialog();
                   });
           }
};
function print_pick_list() {
    printer.print('P006',$('#pick-list-id-hidden').val());
}