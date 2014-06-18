function show_handle_dialog() {
     document.getElementById('handle-dialog-modal').style.display = 'block';
     document.getElementById('dialog-overlay').style.display = 'block';
}

function hide_handle_dialog() {
     document.getElementById('handle-dialog-modal').style.display = 'none';
     document.getElementById('dialog-overlay').style.display = 'none';
}

function data_upload(idStr) {
     // alert('d');
     var vali = true;
     var lock = false;
     var csvReg = /(\.|\/)(csv|tff)$/i;
     $(idStr).fileupload({
          singleFileUploads : false,
          acceptFileTypes : /(\.|\/)(csv|tff)$/i,
          dataType : 'json',
          change : function(e, data) {
               vali = true;
               $(idStr + '-preview').html('');
               $.each(data.files, function(index, file) {
                    var msg = "上传中 ... ...";
                    if(!csvReg.test(file.name)) {
                         msg = '格式错误';
                         vali = false;
                    }
                    show_handle_dialog();
                    $(idStr + '-preview').show().append("<span>文件：" + file.name + "</span><br/><span info>处理中....</span>");
               });
          },
          add : function(e, data) {
               if(vali)
                    if(data.submit != null)
                         data.submit();
          },
          beforeSend : function(xhr) {
               if($('#partrel_update').attr("checked"))
                    xhr.setRequestHeader('CZ-partrel-update', true);
               if($('#strategy_update').attr("checked"))
                    xhr.setRequestHeader('CZ-strategy-update', true);
               xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
          },
          success : function(data) {
                         hide_handle_dialog();
               $(idStr + '-preview > span[info]').html("处理：" + data.content);
          },
          done : function(e, data) {
               // data.context.text('Upload finished.');
          }
     });
}