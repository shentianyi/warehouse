var chosen={};
chosen.init=function(idArray,lengthArray){
    $(".chosen-select").chosen();
    var target,id;
    for(var i=0;i<idArray.length;i++){
       id=idArray[i].indexOf("#")===-1?"#"+idArray[i]:idArray[i];
       id=id.replace(/-/g,"_");
       target=id+"_chosen";
        $(target).width(parseInt(lengthArray[i]));
    }
}
chosen.single_update=function(id,placeholder){
    var id=id.indexOf("#")===-1?"#"+id:id;
    $(id).val('').trigger('chosen:updated');
}
chosen.all_update=function(){
    $(".chosen-select").val('').trigger('chosen:updated');
}
;
