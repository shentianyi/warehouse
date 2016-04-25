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
    respond_to do |format|
      if @storage.update(storage_params)
        format.html { redirect_to @storage, notice: 'Storage was successfully updated.' }
        format.json { render :show, status: :ok, location: @storage }
      else
        format.html { render :edit }
        format.json { render json: @storage.errors, status: :unprocessable_entity }
      end
    end
  end

  def import
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

  def exports
    @condition=params[@model]
    puts @condition
    query=model.unscoped
    where_comdition = ""

    @condition.each do |k, v|
      if (v.is_a?(Fixnum) || v.is_a?(String)) && !v.blank?
        puts @condition.has_key?(k+'_fuzzy')
        if @condition.has_key?(k+'_fuzzy')
          query=query.where("#{k} like ?", "%#{v}%")
          if where_comdition.empty?
            where_comdition += "WHERE #{k} like '#{v}' "
          else
            where_comdition += "AND #{k} = '#{v}' "
          end
        else
          query=query.where(Hash[k, v])
          if where_comdition.empty?
            where_comdition += "WHERE #{k} like '#{v}' "
          else
            where_comdition += "AND #{k} = '#{v}' "
          end
        end
        instance_variable_set("@#{k}", v)
      end

      if v.is_a?(Hash) && v.values.count==2 && v.values.uniq!=['']
        values=v.values.sort
        values[0]=Time.parse(values[0]).utc.to_s if values[0].is_date? & values[0].include?('-')
        values[1]=Time.parse(values[1]).utc.to_s if values[1].is_date? & values[1].include?('-')
        query=query.where(Hash[k, (values[0]..values[1])])
        if where_comdition.empty?
          where_comdition += "WHERE #{k} BETWEEN '#{values[0]}' AND '#{values[1]}' "
        else
          where_comdition += "AND #{k} BETWEEN '#{values[0]}' AND '#{values[1]}' "
        end
        v.each do |kk, vv|
          instance_variable_set("@#{k}_#{kk}", vv)
        end
      end
    end

    if params.has_key? "negative"
      query = query.where("n_storages.qty < 0").select("n_storages.qty as total_qty, n_storages.*")
    else
      if params[:format] == 'xlsx'
        query = query.select("SUM(n_storages.qty) as total_qty, n_storages.*").group("n_storages.partNr, n_storages.ware_house_id, n_storages.position")
      else
        query = NStorage.find_by_sql("select SUM(n_storages.qty) as total_qty, n_storages.* from n_storages #{where_comdition} group by n_storages.partNr, n_storages.ware_house_id, n_storages.position")
      end
    end

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

  def search_by_whouse
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

    if params.has_key? "download"
      send_data(query.to_xlsx(query),
                :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet",
                :filename => @model.pluralize+".xlsx")
      #render :json => query.to_xlsx(query)
    else
      instance_variable_set("@#{@model.pluralize}", query.paginate(:page => params[:page]))
      if params[:n_storage][:ware_house_id]=='WE87'
        render :by_whouse_we87
      elsif params[:n_storage][:ware_house_id]=='PA'
        render :by_whouse_pa
      end
    end
  end

  def by_whouse_we87
    @n_storages= NStorage.where(ware_house_id: 'WE87').paginate(:page => params[:page])
  end

  def by_whouse_pa
    @n_storages= NStorage.where(ware_house_id: 'PA').paginate(:page => params[:page])
  end

  private
# Use callbacks to share common setup or constraints between actions.
  def set_storage
    @storage = NStorage.unscoped.find(params[:id])
  end

  def storage_params
    #params[:order_item]
    params.require(:n_storage).permit(:partNr, :packageId,:ware_house_id,:position,:qty)
  end
end
