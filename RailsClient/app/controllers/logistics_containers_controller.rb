class LogisticsContainersController < ApplicationController

  #在查询时，要做join，针对不同的model,packages,forklifts,deliveries.
  #LogisticsContainer,joins(:container)
  #*2014-11-26 需要重写这段代码，太冗余了。
  #*需要重写,可以join不同的表查询,那么需要注明还要哪些表来进行查询
  def search
    puts params
    model = params[:model]
    @condition=params[model.to_sym]
    query = LogisticsContainer.uniq

    joins = ["location_containers"]
    args = [model]

    #if params[:tables]
    tables = params[:tables].nil? ? [] : params[:tables].split(';')
    (tables  + ["#{model}"]).each { |t|
      if t=='records'
       query=query.joins("LEFT JOIN `records` ON `records`.`recordable_id` = `location_containers`.`id`
 AND `records`.`recordable_type` = 'LocationContainer'")
      else
        query = query.joins(t.to_sym)
      end
    }
    joins = joins + tables
    args = args + tables
    #end

    hash_conditions = {}

    res = joins.zip(args)

    puts "====#{res}"

    res.each do |table, arg|
      puts "------------#{table},#{arg}"
      condition = params[arg.to_sym]
      puts condition
      condition.each do |k, v|
        if (v.is_a?(Fixnum) || v.is_a?(String)) && !v.blank?
          if condition.has_key?(k+'_fuzzy')
            query = query.where("#{table.pluralize}.#{k} like ?", "%#{v}%")
          else
            hash_conditions[table.to_sym] = Hash[k, v]
          end
          instance_variable_set("@#{arg}_#{k}", v)
        end

        if v.is_a?(Hash) && v.values.count==2 && v.values.uniq!=['']
          values=v.values.sort
          values[0]=Time.parse(values[0]).utc.to_s if values[0].is_date?
          values[1]=Time.parse(values[1]).utc.to_s if values[1].is_date?
          hash_conditions[table.to_sym] = Hash[k, (values[0]..values[1])]
          v.each do |kk, vv|
            instance_variable_set("@#{arg}_#{k}_#{kk}", vv)
          end
        end
      end
    end
    # raise
    #puts "=================="
    puts '------------------------------------------------------------'
    puts hash_conditions

    containers={}
    if params[:containers].present? && params[:containers][:part_id].present?
      containers[:part_id]=Part.where("nr like ?",  "%#{params[:containers][:part_id]}%").pluck(:id)
      instance_variable_set("@container_part_id", params[:containers][:part_id])
    end

    if params[:containers].present? && params[:containers][:extra_batch].present?
      containers[:extra_batch]=params[:containers][:extra_batch]
      instance_variable_set("@container_extra_batch", params[:containers][:extra_batch])
    end

    if params[:containers].present? && params[:containers][:fifo_time][:start].present? && params[:containers][:fifo_time][:end].present?
      containers[:fifo_time]=(Time.parse(params[:containers][:fifo_time][:start]).utc.to_s..Time.parse(params[:containers][:fifo_time][:end]).utc.to_s)
      instance_variable_set("@delivery_fifo_time_start", params[:containers][:fifo_time][:start])
      instance_variable_set("@delivery_fifo_time_end", params[:containers][:fifo_time][:end])
    end

    unless containers.blank?
      hash_conditions[:containers]=containers
    end

    # query.first
    query=query.where(hash_conditions)

    query=query.where('des_location_id=? or source_location_id=?', current_user.location.id, current_user.location.id).order(des_location_id: :desc)
    instance_variable_set("@#{model.pluralize}", query.paginate(:page => params[:page]).all.order(created_at: :desc))

    # puts "---------------------"
    # puts query.paginate(:page => params[:page]).all.order(created_at: :desc).to_json

    if params.has_key? "download"
      send_data(DeliveryService.to_xlsx(query),
                :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet",
                :filename => model.pluralize+".xlsx")
    else
      render "#{model.pluralize}/index"
    end
  end

  def export
    json={}
    parent=LogisticsContainer.find(params[:id])
    if !parent.is_root?
      redirect_to send("#{ContainerType.get_type_name(parent.container.type).pluralize}_path"), notice: "该#{ContainerType.get_type_name(parent.container.type)}不能被导出，因为不是单独发运的。"
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
