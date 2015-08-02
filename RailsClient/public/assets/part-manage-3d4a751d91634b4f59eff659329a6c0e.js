var Manage =  Manage || {};

Manage.part = {};

Manage.part.del_position = function(id,target){
    var id = id;
    var target = $(target);
    $.ajax({
        url:'/parts/delete_position/'+id,
        type:'DELETE',
        dataType:'json',
        success:function(data){
            if(data.result){
                target.parent().remove();
            }
        }
    })
}
;
