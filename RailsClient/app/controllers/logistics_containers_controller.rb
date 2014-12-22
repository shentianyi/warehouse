class LogisticsContainersController < ApplicationController

  #在查询时，要做join，针对不同的model,packages,forklifts,deliveries.
  #LogisticsContainer,joins(:container)
  #*2014-11-26 需要重写这段代码，太冗余了。
  #*需要重写,可以join不同的表查询,那么需要注明还要哪些表来进行查询
  def search
    model = params[:model]
    @condition=params[model.to_sym]
    query = LogisticsContainer

    joins = ["location_containers"]
    args = [model]

    #if params[:tables]
    tables = params[:tables].nil? ? [] : params[:tables].split(';')
    (tables - ["container"] + ["#{model}"]).each { |t|
      query = query.joins(t.to_sym)
    }
    joins = joins + tables
    args = args + tables
    #end

    hash_conditions = {}

    res = joins.zip(args)

    puts "====#{res}"

    res.each do |table, arg|
      puts "#{table},#{arg}"
      condition = params[arg.to_sym]
      puts condition
      condition.each do |k, v|
        if (v.is_a?(Fixnum) || v.is_a?(String)) && !v.blank?
          if condition.has_key?(k+'_fuzzy')
            query = query.where("#{table.pluralize}.#{k} like ?", "%#{v}%")
          else
            hash_conditions[table.to_sym] = Hash[k, v]
          end
          puts "--#{arg}_#{k}"
          instance_variable_set("@#{arg}_#{k}", v)
        end
        if v.is_a?(Hash) && v.values.count==2 && v.values.uniq!=['']
          values=v.values.sort
          values[0]=Time.parse(values[0]).utc.to_s if values[0].is_date?
          values[1]=Time.parse(values[1]).utc.to_s if values[1].is_date?
          hash_conditions[table.to_sym] = Hash[k, (values[0]..values[1])]
          v.each do |kk, vv|
            puts "--#{arg}_#{k}_#{kk}"
            instance_variable_set("@#{arg}_#{k}_#{kk}", vv)
          end
        end
      end
    end
    #puts "=================="
    #puts hash_conditions

    query=query.where(hash_conditions)

    query.first

    instance_variable_set("@#{model.pluralize}", query.paginate(:page => params[:page]).all.order(created_at: :desc))
    render "#{model.pluralize}/index"
    #render :json => 1
  end

  def export
    json={}
    parent=LogisticsContainer.find(params[:id])
    if !parent.is_root?
      redirect_to send("#{ContainerType.get_type_name(parent.container.type).pluralize}_path"),notice: "该#{ContainerType.get_type_name(parent.container.type)}不能被导出，因为不是单独发运的。"
    else
      lcs=parent.subtree
      json[:logistics_containers]=lcs
      json[:records]=[]
      json[:containers]=[]
      lcs.each do |lc|
        json[:containers]<<lc.container
        json[:records]+=lc.records
      end
      send_data json.to_json, :filename => "#{parent.container_id}.json"
    end
  end

  def import
    if request.post?
      msg=Message.new
      if params[:files].size==1
        file=params[:files][0]
        data=FileData.new(data: file, oriName: file.original_filename, path: $DELIVERYPATH, pathName: "#{Time.now.strftime('%Y%m%d%H%M%S')}-#{file.original_filename}")
        data.saveFile
        msg=DeliveryService.import_by_file(data.full_path)
        msg.content= msg.result ? '运单导入成功' : msg.content
      else
        msg.content='未选择文件或只能上传一个文件'
      end
      render json: msg
    end
  end
end
