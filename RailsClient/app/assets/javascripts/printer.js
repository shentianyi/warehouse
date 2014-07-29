var printer={
           url:function(code,id){
               return $('#print-server-hidden').val()+code+'/'+id;
           },
           print:function(code,id){
               if(confirm('确认打印？')){
               show_handle_dialog();
               var url=this.url(code,id);
               $.ajax({
                   url: url,
                   type: 'get',
                   dataType: 'json',
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
           }   }
};
function print_forklift_list(id){
    printer.print('P001',id);
}
function print_delivery_list(id){
    printer.print('P002',id);
}
function print_delivery_confirm_list(id){
    printer.print('P003',id);
}
function print_delivery_unrece_list(id){
    printer.print('P004',id);
}
function print_delivery_reve_list(id){
    printer.print('P005',id);
}
function print_pick_list(id) {
    printer.print('P006',id);
}