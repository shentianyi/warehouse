var pm={};pm.get_filters=function(e,t){$.get("/orders/filters",{user:e},function(e){t&&t(e)},"html")},pm.refresh_orders_items=function(){var e=[];$(".order-checkbox:checked").each(function(){e.push($(this).val())}),0==e.length?$(".order-content-div").html('<div class="alert" role="alert"><h3>\u8bf7\u52fe\u9009\u5de6\u4fa7\u9700\u6c42\u5355\u5217\u8868\u6765\u9884\u89c8</h3></div>'):$.get("/orders/items",{user_id:$("#user-id-text").val(),order_ids:e},function(e){$(".order-content-div").html(e)},"html")},pm.build_pick_list=function(){var e=$("#user-id-text").val(),t=[];return $("#order-list-panel-inner .order-checkbox:checked").each(function(){t.push($(this).val())}),e?0==t.length?void alert("\u8bf7\u9009\u62e9\u9700\u8981\u5904\u7406\u7684\u9700\u6c42\u5355"):(show_handle_dialog(),void $.post("/pick_lists/",{user_id:e,order_ids:t},function(e){hide_handle_dialog(),e.result?window.location="/pick_lists/"+e.content.id:(void 0==e.content&&(e.content="\u521b\u5efa\u5219\u8d27\u5355\u5931\u8d25\uff0c\u60a8\u53ef\u80fd\u6ca1\u6709\u62e9\u8d27\u89c4\u5219\uff01"),alert(e.content))},"json")):void alert("\u8bf7\u8f93\u5165\u62e9\u8d27\u5458\u5de5\u53f7")},pm.change_user_id=function(e){pm.get_filters(e,function(e){$(".chosen-select").html(e),chosen.all_update()}),$("#select-all").prop("checked",!1).trigger("change"),$.get("/orders/picklists",{user_id:e},function(e){$("#pick-list").html(e)},"html")};