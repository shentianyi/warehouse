module ApplicationHelper

  def import
    render 'shared/import'
  end

  def do_import
    msg=Message.new
    begin
      if params[:files].size==1
        file=params[:files][0]
        data=FileData.new(data: file, oriName: file.original_filename, path: $UPDATAPATH, pathName: "#{Time.now.strftime('%Y%m%d%H%M%S')}-#{file.original_filename}")
        data.saveFile
        csv=Csv::CsvConfig.new(encoding: Csv::CsvConfig.csv_write_encode(request.user_agent), col_sep: $CSVSP, file_path: data.full_path)
        msg=model.import_csv(csv)
      else
        msg.content='未选择文件或只能上传一个文件'
      end
    rescue => e
      puts e.backtrace
      msg.content = e.message
    end
    render json: msg
  end

  def search
    @items=model.where(params[@model].clone.delete_if { |k, v| v.length==0 }).paginate(:page => params[:page], :per_page => 20)
    render :index
  end

  def download
    query=nil
    file_name= @model+'_'+Time.now.strftime('%Y%m%d%H%M%S')+'.csv'
    path=File.join($DOWNLOADPATH, file_name)
    @msg= model.export_csv(path, query)
    if @msg.result
      send_file path, :type => 'application/csv', :filename => file_name
    else
      render :index
    end
  end

  def template
    file_name="#{@model}_csv_upload_template.csv"
    path=File.join($TEMPLATEPATH, file_name)
    send_file path, :type => 'application/csv', :filename => file_name
  end
end
