var Manage =  Manage || {};

Manage.part = {};

Manage.part.del_position = function(id){
    var id = id;
    $.ajax({
        url:'parts/delete_position',
        type:'DELETE',
        data:{id:id},
        dataType:'json',
        success:function(data){
            if(data.result){

            }
        }
    })
}