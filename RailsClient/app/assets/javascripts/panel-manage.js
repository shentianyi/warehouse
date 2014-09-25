var pm = {};

pm.get_filters = function(user_id,callback){
    $.get('/orders/filters',{user:user_id},function(data){
        if(callback) {
            callback(data)
        }
    },'html');
};