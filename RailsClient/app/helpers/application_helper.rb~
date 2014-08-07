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

  #def search
  #  @items=model.where(params[@model].clone.delete_if { |k, v| v.length==0 }).paginate(:page => params[:page])
  #  render :index
  #end

  def search
    @condition=params[@model]
    query=model
    @condition.each do |k, v|
      if (v.is_a?(Fixnum) || v.is_a?(String)) && !v.blank?
        puts @condition.has_key?(k+'_fuzzy')
        if @condition.has_key?(k+'_fuzzy')
          query=query.where("#{k} like ?", "%#{v}%")
        else
          query=query.where(Hash[k, v])
        end
        instance_variable_set("@#{k}", v)
      end
      #if v.is_a?(Array) && !v.empty?
      #  query= v.size==1 ? query.where(Hash[k, v[0]]) : query.in(Hash[k, v])
      #end
      #query=query.where(Hash[k, v]) if v.is_a?(Range)
      if v.is_a?(Hash) && v.values.count==2 && v.values.uniq!=['']
        query=query.where(Hash[k, (v.values[0]..v.values[1])])
        v.each do |kk, vv|
          instance_variable_set("@#{k}_#{kk}", vv)
        end
      end
    end
    instance_variable_set("@#{@model.pluralize}", query.paginate(:page => params[:page]).all)
    render :index
  end


  def download
    query=nil
    file_name= @model+'_'+Time.now.strftime('%Y%m%d%H%M%S')+'.csv'
    path=File.join($DOWNLOADPATH, file_name)
    @msg= model.export_csv(path, query)
    send_file path, :type => 'application/csv', :filename => file_name
  end

  def template
    file_name="#{@model}_csv_upload_template.csv"
    path=File.join($TEMPLATEPATH, file_name)
    send_file path, :type => 'application/csv', :filename => file_name
  end
end
