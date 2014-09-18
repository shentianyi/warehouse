$(document).ready(function () {

});


var Report = Report || {};

Report.get = function(){
    var type = 0;
    var location_id = 'l002';
    var format = 'csv';
    var date_start = $("#date-start").val();
    var date_end = $("#date-end").val();

    $.get('/reports/reports',{type:type,location_id:location_id,format:format,date_start:date_start,date_end:date_end},function(){

    },'html');
};