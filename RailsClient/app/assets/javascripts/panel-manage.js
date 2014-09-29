var pm = {};

pm.get_filters = function(user_id,callback){
    $.get('/orders/filters',{user:user_id},function(data){
        if(callback) {
            callback(data)
        }
    },'html');
};

pm.refresh_orders_items = function(){
    var orders = [];
    $('.order-checkbox:checked').each(function () {
        orders.push($(this).val());
    });
    if (orders.length == 0) {
        $('.order-content-div').html('<div class="alert" role="alert"><h3>请勾选左侧需求单列表来预览</h3></div>');
    } else {
        $.get('/orders/items', {user_id: $('#user-id-text').val(), order_ids: orders}, function (data) {
            $('.order-content-div').html(data);
        }, 'html');
    }
};

pm.build_pick_list = function(){
    var user = $('#user-id-text').val();
    var orders = [];
    $('#order-list-panel-inner .order-checkbox:checked').each(function () {
        orders.push($(this).val());
    });
    if (!user) {
        alert('请输入择货员工号');
        return;
    }
    if (orders.length == 0) {
        alert('请选择需要处理的需求单');
        return;
    }
    show_handle_dialog();
    $.post('/pick_lists/', {user_id: user, order_ids: orders}, function (data) {
        hide_handle_dialog();
        if (data.result) {
            window.location = '/pick_lists/' + data.content.id;
        } else {
            if(data.content == undefined){
                data.content = '创建则货单失败，您可能没有择货规则！'
            }
            alert(data.content);
        }
    }, 'json');
};

pm.change_user_id = function(user_id){
    //refresi filters
    pm.get_filters(user_id, function (data) {
        $(".chosen-select").html(data);
        //reinit chosen selecg
        chosen.all_update();
    });
    //un select all order
    $("#select-all,#select-all-inner").prop("checked",false).trigger("change");
    //refresh picklist
    $.get('/orders/picklists',{user_id:user_id},function(data){
        $("#pick-list").html(data);
    },'html');
}