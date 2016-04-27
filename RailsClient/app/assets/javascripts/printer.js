var printer = {
    url: function (code) {
        return $('#print-server-hidden').val() + code + '/' + this.id();
    },
    print: function (code) {
        if (this.id() && confirm('确认打印？')) {
            show_handle_dialog();
            var url = this.url(code);
            $.ajax({
                url: url,
                type: 'get',
                dataType: 'json',
                timeout: 10000,
                crossDomain: true,
                success: function (data) {
                    if (data) {
                        alert(data.Content);
                    } else {
                        alert('打印失败，请开启打印服务器或重新配置');
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    console.log(XMLHttpRequest.status);
                    if (XMLHttpRequest.status == 500) {
                        alert('打印打印服务程序内部错误，请联系系统管理员或服务商');
                    } else {
                        alert('无法连接打印服务器，请开启打印服务器或重新配置 或 打印被取消');
                    }
                }
            }).always(function () {
                hide_handle_dialog();
            });
        }
    },
    id: null
};
function print_forklift_list() {
    printer.print('P001');
}
function print_delivery_list() {
    printer.print('P002');
}
function print_delivery_confirm_list() {
    printer.print('P003');
}
function print_delivery_unrece_list() {
    printer.print('P004');
}
function print_delivery_reve_list() {
    printer.print('P005');
}
function print_pick_list() {
    printer.print('P006');
}
function print_pick_list_with_id(id) {
    printer.id = function () {
        return id
    };
    printer.print('P006');
}

function print_back_parts_with_id(id) {
    printer.print('P011');
}

function init_check() {
    $('body').on('change', '.print-check', function () {
        $(this).prop('checked', $(this).is(':checked'));
        $('.print-check').not(this).prop('checked', false);
    });
    printer.id = function () {
        return $('.print-check:checked').attr('id');
    }
}