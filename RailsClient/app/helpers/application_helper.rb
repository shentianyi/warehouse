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
    query=model.all #.unscoped
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
      #  query= v.size==1 ? query.where(Hash[k, v[0]]) : query.in(Hash[k, v]
      #end
      #query=query.where(Hash[k, v]) if v.is_a?(Range)
      if v.is_a?(Hash) && v.values.count==2 && v.values.uniq!=['']
        values=v.values.sort
        values[0]=Time.parse(values[0]).utc.to_s if values[0].is_date? & values[0].include?('-')
        values[1]=Time.parse(values[1]).utc.to_s if values[1].is_date? & values[1].include?('-')
        query=query.where(Hash[k, (values[0]..values[1])])
        v.each do |kk, vv|
          instance_variable_set("@#{k}_#{kk}", vv)
        end
      end
    end

    if block_given?
      query=(yield query)
    end

    if params.has_key? "download"
      send_data(query.to_xlsx(query),
                :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet",
                :filename => @model.pluralize+".xlsx")
      #render :json => query.to_xlsx(query)
    else
      instance_variable_set("@#{@model.pluralize}", query.paginate(:page => params[:page]).all)
      render :index
    end
  end

  def download
    query=nil
    file_name= @model+'_'+Time.now.strftime('%Y%m%d%H%M%S')+'.csv'
    path=File.join($DOWNLOADPATH, file_name)
    @msg= model.export_csv(path, query, request.user_agent)
    send_file path, :type => 'application/csv', :filename => file_name
  end

  def template
    if params[:extend].blank? || params[:extend]=='csv'
      # file_name="#{@model}_csv_upload_template.csv"
      case @model
        when "part"
          file_name="上传零件模版.csv"
        when "led"
          file_name="上传LED灯模版.csv"
        when "location"
          file_name="上传地点信息模版.csv"
        when "modem"
          file_name="上传modem模版.csv"
        when "part_position"
          file_name="上传零件位置模版.csv"
        when "part_type"
          file_name="上传零件类型模版.csv"
        when "pick_item_filter"
          file_name="上传择货项模版.csv"
        when "position"
          file_name="上传库位模版.csv"
        when "user"
          file_name="上传用户模版.csv"
        when "whouse"
          file_name="上传仓库模版.csv"
      end

      path=File.join($TEMPLATEPATH, file_name)
      send_file path, :type => 'application/csv', :filename => file_name
    else
      file_name="#{@model}_excel_upload_template.excel"
      path=File.join($TEMPLATEPATH, file_name)
      send_file path, :filename => file_name
    end
  end
end
