function save_base_config(type) {
    if (confirm('确定执行？')) {
        show_handle_dialog();
        var data = null;
        if (type == 'basic') {
            data = {config: {
                host: $('#host').val(),
                token: $('#token').val(),
                sync_lock: $('#sync_lock').prop('checked'),
                enabled: $('#enabled').prop('checked'),
                advance_second: $('#advance_second').val(),
                per_request_size: $('#per_request_size').val(),
                lock: $('#lock').prop('checked')
            }};
        } else if (type == 'sync') {
            data = {config: {last_time: $('#last_time').val()}};
            var callback = function (data) {
                if (data.result)
                    $('#last_time').val(data.content);
            }
        } else if (type == 'exe') {
            data = {config: {}};
            $(".exe_key").each(function (i, ele) {
                var key = $(ele).attr('key');
                console.log(key);
                data['config'][key] = {
                    get: $('#' + key + '-get').prop('checked'),
                    post: $('#' + key + '-post').prop('checked'),
                    put: $('#' + key + '-put').prop('checked'),
                    delete: $('#' + key + '-delete').prop('checked')
                };
            });
        }
        $.ajax({
            url: '/syncs/' + type,
            data: data,
            dataType: 'json',
            type: 'PUT',
            success: function (data) {
                alert('成功执行！');
                if (callback) {
                    callback(data);
                }
            }
        });
        hide_handle_dialog();
    }
}

function save_regex(type) {
    if (confirm('确定更改？')) {
        var regexes = [];
        $('.package-label-regex').each(function () {
            var regex = {id: $(this).attr('id')};
            regex.prefix_string = $(this).find('.prefix_string').val();
            regex.suffix_string = $(this).find('.suffix_string').val();
            regex.regex_string = $(this).find('.regex_string').val();
            regex.remark = $(this).find('.remark').val();
            regexes.push(regex);
        });
        $.post('/regexes/save', {type: type, regexes: regexes}, function (data) {
              alert('保存成功,请重新启动所有APP客户端');
        }, 'json');
    }
}