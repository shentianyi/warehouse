require 'will_paginate/array'

class NStoragesController < ApplicationController
  before_action :set_storage, only: [:show, :edit, :update, :destroy]

# GET /deliveries
  def index
    @n_storages= NStorage.paginate(:page => params[:page])
  end

#def search
#  @n_storages=NStorage
#  if params[:partNr].present?
#    @n_storages=@n_storages.where("partNr like '%#{params[:partNr]}%' AND ware_house_id like '%#{params[:toWh]}%' ")
#   @partNr=params[:partNr]
#  @toWh=params[:toWh]

#    end
#   @n_storages=@n_storages.paginate(:page => params[:page])
#  render :index
# end


  def update
    move_data = {
        to_id: params[:n_storage][:ware_house_id],
        toPosition: params[:n_storage][:position],
        type_id: MoveType.find_by!(typeId: 'MOVE').id,
        partNr: @storage.partNr,
        fifo: @storage.fifo,
        qty: @storage.qty,
        from_id: @storage.ware_house_id,
        fromPosition: @storage.position,
        packageId: @storage.packageId,
        remark: @storage.remarks,
        employee_id: current_user
    }
    puts move_data
    respond_to do |format|
      if @storage.update(storage_params)
        Movement.create!(move_data)
        format.html { redirect_to @storage, notice: 'Storage was successfully updated.' }
        format.json { render :show, status: :ok, location: @storage }
      else
        format.html { render :edit }
        format.json { render json: @storage.errors, status: :unprocessable_entity }
      end
    end
  end

  def import
    # raise '盘点模式,非超级管理员权限不可更改数据!' if (SysConfigCache.inventory_enable_value=='true' && !current_user.supermanager?)
    if request.post?
      msg = Message.new
      begin
        file=params[:files][0]
        fd = FileData.new(data: file, oriName: file.original_filename, path: $tmp_file_path, pathName: "#{Time.now.strftime('%Y%m%d%H%M%S%L')}~#{file.original_filename}")
        fd.save
        msg = FileHandler::Excel::NStorageHandler.import(fd, current_user)
      rescue => e
        msg.content = e.message
      end
      render json: msg
    end
  end

  def move
    # raise '盘点模式,非超级管理员权限不可更改数据!' if (SysConfigCache.inventory_enable_value=='true' && !current_user.supermanager?)
    if request.post?
      msg = Message.new
      begin
        file=params[:files][0]
        fd = FileData.new(data: file, oriName: file.original_filename, path: $tmp_file_path, pathName: "#{Time.now.strftime('%Y%m%d%H%M%S%L')}~#{file.original_filename}")
        fd.save
        msg = FileHandler::Excel::NStorageHandler.move(fd, current_user)
      rescue => e
        msg.content = e.message
      end
      render json: msg
    end
  end

  def search
    super { |query|
      if params[:n_storage][:partNr].present?
        query=query.unscope(where: :partNr) #.where(partNr: part.id)
        query=query.joins("inner join parts on n_storages.partNr=parts.id").where("parts.nr like '%#{params[:n_storage][:partNr]}%'")
      end

      if whouse=Whouse.find_by_nr(params[:n_storage][:ware_house_id])
        query=query.unscope(where: :ware_house_id).where(ware_house_id: whouse.id)
      end

      if params[:n_storage][:position_id].present?
        query=query.unscope(where: :position_id) #.where(position_id: position.id)
        query=query.joins("inner join positions on n_storages.position_id=positions.id").where("positions.nr like '%#{params[:n_storage][:position_id]}%'")
      end

      unless params[:part][:package_type].blank?
        query=query.joins(:part).where(parts: {package_type_id: params[:part][:package_type]})
        instance_variable_set("@package_type", params[:part][:package_type])
      end

      query
    }
  end

  def exports
    @condition=params[@model]

    whouse=Whouse.find_by_nr(@condition[:ware_house_id])
    query=model.unscoped

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

    instance_variable_set("@ware_house_id", whouse.name) if whouse
    unless @condition[:position_id].blank?
      query=query.unscope(where: :position_id) #.where(position_id: position.id)
      query=query.joins("inner join positions on n_storages.position_id=positions.id").where("positions.nr like '%#{params[:n_storage][:position_id]}%'")

    end

    query=query.unscope(where: :partNr)
    query = query.joins(:part).where("parts.nr like '%#{params[:n_storage][:partNr]}%'")

    # if @condition[:partNr].present? && params[:part][:package_type].present?
    #   query=query.unscope(where: :partNr)
    #   query = query.joins(part: :package_type)
    #               .where("parts.nr like '%#{params[:n_storage][:partNr]}%'")
    #               .where("package_types.id=#{params[:part][:package_type]}")
    #   instance_variable_set("@package_type", params[:part][:package_type])
    # elsif @condition[:partNr].present? && params[:part][:package_type].blank?
    #   query=query.unscope(where: :partNr)
    #   query = query.joins(part: :package_type).where("parts.nr like '%#{params[:n_storage][:partNr]}%'")
    # elsif @condition[:partNr].blank? && params[:part][:package_type].present?
    #   query = query.joins(part: :package_type).where("package_types.id=#{params[:part][:package_type]}")
    #   instance_variable_set("@package_type", params[:part][:package_type])
    # end

    # query = query.where(locked: false)
    query = query.select("SUM(n_storages.qty) as total_qty, n_storages.*")
                .group("n_storages.partNr")
                # .group("n_storages.partNr, n_storages.ware_house_id, n_storages.position_id")

    instance_variable_set("@#{@model.pluralize}", query.paginate(:page => params[:page]))

    respond_to do |format|
      format.xlsx do
        send_data(query.to_total_xlsx(query),
                  :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet",
                  :filename => "库存查询导出.xlsx")
      end

      format.html do
        render :group
      end
    end
  end


  private
# Use callbacks to share common setup or constraints between actions.
  def set_storage
    @storage = NStorage.unscoped.find(params[:id])
  end

  def storage_params
    #params[:order_item]
    params.require(:n_storage).permit(:partNr, :packageId, :ware_house_id, :position, :qty)
  end
end
