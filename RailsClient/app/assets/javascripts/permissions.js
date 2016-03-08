/**
 * Created by if on 16-2-25.
 */
var ClientHeight = document.documentElement.clientHeight;
function SetCheckBoxValue() {
    $(".CheckBox").click(function () {
        if ($(this).attr('ischecked') == "true") {
            $(this).attr('ischecked', 'false');
        } else {
            $(this).attr('ischecked', 'true');
        }
    });
}

function SetModalPosition(id) {
    $(id).css({height: (ClientHeight - 450) / 2 + 'px'});
}

function RemovePermissionGroupsTips() {
    $('.ShowPermissionTipsCaret').remove();
    $('.ShowPermissionTips').remove();
}