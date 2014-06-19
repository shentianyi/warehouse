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

  def download query=nil, mm=nil
    file_name=@model+".csv"
    path=File.join($DOWNLOADPATH, file_name)
    File.open(path, 'wb') do |f|
      m=mm.nil? ? model : mm
      f.puts m.csv_headers.join($CSVSP)
      items=query.nil? ? m.all : m.where(query)
      items.each do |item|
        line=[]
        proc=BlockHelper.send "get_#{@model}_down_block"
        proc.call(line, item)
        f.puts line.join($CSVSP)
      end
    end
    send_file path, :type => 'application/csv', :filename => file_name
  end

  def template
    file_name="#{@model}_csv_upload_template.csv"
    path=File.join($TEMPLATEPATH, file_name)
    send_file path, :type => 'application/csv', :filename => file_name
  end


end
