var wms = wms || {};

wms.init = function(){
    //inti user
    wms.user_id = $("#user-id-text").val();
    wms.order.initial_lists();
};

wms.order = {};
wms.order.lists = [];

wms.order.initial_lists = function(){
    //initial order lists id
    wms.order.lists = [];
    $(".order").each(function(){
        //order should contain "order" class and "order_id" attribute
        wms.order.lists.push($(this).attr("order_id"));
    });
};

wms.order.order_lists = function(callback){
    wms.order.initial_lists();
    var orders = wms.order.lists;
    $.ajax({
        url:'/orders/panel_list',
        dataType:'html',
        data:{orders: orders},
        type:'get',
        success: function(data){
            if(callback){
                callback(data);
            }
        },
        error: function(){

        },
        complete: function(xhr){
            if(xhr.status == 304 ) return;
        }
    })
};

wms.order.order_lists_by_filter = function(filters,callback){
    wms.order.initial_lists();
    $.get('/orders/filt', {filters: filters, orders:wms.order.lists,user_id:wms.user_id }, function (data) {
        if(callback) {
            callback(data);
        }
    }, 'html');
};
