function show_handle_dialog() {
    document.getElementById('handle-dialog-modal').style.display = 'block';
    document.getElementById('dialog-overlay').style.display = 'block';
}

function hide_handle_dialog() {
    document.getElementById('handle-dialog-modal').style.display = 'none';
    document.getElementById('dialog-overlay').style.display = 'none';
}

function data_upload(idStr, format, callback) {
    var vali = true;
    var lock = false;
    var reg = /(\.|\/)(josn|csv|tff)$/i;
    if (format != null) {
        if (format != false) {
            reg = new RegExp('(\.|\/)(' + format + ')$', 'i');
        } else {
            reg = null;
        }
    }

    $(idStr).fileupload({
        singleFileUploads: false,
        acceptFileTypes: /(\.|\/)(json|csv|tff)$/i,
        dataType: 'json',
        change: function (e, data) {
            vali = true;
            $(idStr + '-preview').html('');
            $.each(data.files, function (index, file) {
                var msg = "上传中 ... ...";
                if (reg) {
                    if (!reg.test(file.name)) {
                        msg = '格式错误';
                        alert(msg);
                        vali = false;
                        return;
                    }
                    show_handle_dialog();
                }
                $(idStr + '-preview').show().append("<span>文件：" + file.name + "</span><br/><span info>处理中....</span>");
            });
        },
        add: function (e, data) {
            if (vali)
                if (data.submit != null)
                    data.submit();
        },
        beforeSend: function (xhr) {
            if ($('#partrel_update').attr("checked"))
                xhr.setRequestHeader('CZ-partrel-update', true);
            if ($('#strategy_update').attr("checked"))
                xhr.setRequestHeader('CZ-strategy-update', true);
            xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
        },
        success: function (data) {
            if (callback) {
                callback(data);
            } else {
                hide_handle_dialog();
                $(idStr + '-preview > span[info]').html("处理：" + data.content);
            }
        },
        done: function (e, data) {
        }
    });
}

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
                per_request_size:$('#per_request_size').val()
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