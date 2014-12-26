/**
 * Created by liqi on 12/26/14.
 */
var Manage = Manage || {};
Manage.pick_item = {};
Manage.pick_item.update = function(id,params,callback){
    $.ajax({
        url:'/pick_items/'+id,
        type:'PUT',
        dataType:'json',
        data:params,
        success:function(data){
            if(callback){
                callback(data);
            }
        }
    })
};