class InventoryListItem < ActiveRecord::Base
  #belongs_to :package
  #belongs_to :part
  belongs_to :position_object, class_name: 'Position', foreign_key: :position
  belongs_to :part
  belongs_to :user
  belongs_to :whouse
  belongs_to :inventory_list


  belongs_to :current_whouse_object, class_name: 'Whouse', foreign_key: :current_whouse
  belongs_to :current_position_object, class_name: 'Position', foreign_key: :current_position

  validates :qty, :inventory_list_id, presence: true
  validates_inclusion_of :in_store, in: [true, false]

  has_paper_trail

  def position_nr
    if p=Position.find_by_id(self.position)
      p.nr
    end
  end


  def whouse_nr
    self.whouse.blank? ? '' : self.whouse.nr
  end

  def current_whouse_nr
    self.current_whouse_object.blank? ? '' : self.current_whouse_object.nr
  end


  def current_position_nr
    self.current_position_object.blank? ? '' : self.current_position_object.nr
  end

  def user_nr
    self.user.blank? ? '' : self.user.nr
  end

  def self.new_item(params, query=true)
    # 根据参数组合情况获取nstorage end
    part=Part.find_by_nr(params[:part_id])
    params[:part_id]=part.blank? ? params[:part_id] : part.id
    position=Position.find_by_nr(params[:position])
    params[:position]=position.blank? ? params[:position] : position.id
    if query
      query = NStorage.new

      # 根据参数组合情况获取nstorage start
      if !params[:package_id].blank?
        if InventoryListItem.where(package_id: params[:package_id],
                                   inventory_list_id: params[:inventory_list_id]).first
          raise '已盘点'
        end
        query = NStorage.where(packageId: params[:package_id]).first
      elsif !params[:unique_id].blank?
        query = NStorage.where(uniqueid: params[:unique_id]).first
      elsif !params[:part_id].blank? && !params[:position].blank?
        #XXXXXXXXXX
        query=NStorage.where(partNr: params[:part_id], position: params[:position]).first
      else
        query = nil
      end

      # 已入库，参数组合生成
      if query.nil?
        params[:current_whouse] = nil if params[:current_whouse].blank?
        params[:current_position] = nil
        params[:in_store] = false if params[:current_position].blank?
      else
        params[:current_whouse] = query.ware_house_id if params[:current_whouse].blank?
        params[:current_position] = query.position if params[:current_position].blank?
        params[:in_store] = true
        params[:fifo]=query.fifo if params[:fifo].blank?
        params[:origin_qty] =params[:qty]=query.qty if params[:qty].blank?
        if params[:part_id].blank?
          params[:part_id] = query.partNr
        end
      end
    end

    if params[:need_convert]
      params[:qty]=BigDecimal.new(params[:qty].to_s)/BigDecimal.new(part.convert_unit.to_s)
    else
      params[:qty]=BigDecimal.new(params[:qty].to_s)
    end

    if params[:part_wire_mark].blank?
      params[:part_wire_mark]=part.is_wire? ? 'L' : 'M'
    end

    if params[:whouse_id].blank?
      params[:whouse_id]=InventoryList.find(params[:inventory_list_id]).whouse_id
    end

    # 存在nstorage记录，且传入part_id为nil则使用nstorage的partNr，否则默认使用传入的part_id
    # 赋值
    # inventory_list_item = InventoryListItem.new(:package_id => package_id, :unique_id => unique_id,
    #                                             :part_id => part_id, :qty => qty, :position => position, :current_whouse => current_whouse,
    #                                             :current_position => current_position, :user_id => user_id, :in_store => in_store,
    # :inventory_list_id => inventory_list_id)
    inventory_list_item=InventoryListItem.new(params)
    puts inventory_list_item.to_json
    # 保存
    if inventory_list_item.save!
      return inventory_list_item
    else
      return nil
    end

  end


  def enter_stock
    message=Message.new
    begin
      params={
          partNr: self.part_id,
          qty: self.qty,
          fifo: self.fifo.present? ? self.fifo_display : nil,
          packageId: self.package_id.present? ? self.package_id : nil,
          toWh: self.whouse_id.present? ? self.whouse_id : nil,
          toPosition: self.position.present? ? self.position : nil,
          remarks: "盘点入库,盘点单：#{self.inventory_list.name}",
          uniq: true
      }
      puts '--------------------------------------'
      puts params.to_json
      puts '--------------------------------------'
      StorageOperationRecord.save_record(params, 'ENTRY')
      WhouseService.new.enter_stock(params)
      message.result=true
    rescue => e
      message.result=false
      message.content=e.message
    end
    message
  end

  def fifo_display
    if self.fifo
      self.fifo.localtime.strftime('%Y/%m/%d')
    end
  end

  def qty_export_display
    self.qty.round.to_i
  end

  def fifo_export_display
    if self.fifo
      self.fifo.localtime.strftime('%d.%m.%y')
    end
  end

  def fifo_display=(v)
    self.fifo=v.to_time.utc
  end

  def need_convert_display
    self.need_convert? ? 'Y' : 'N'
  end

  def in_store_display
    self.in_store? ? 'Y' : 'N'
  end

  def locked_display
    self.locked? ? 'Y' : 'N'
  end


  # 盘点项手动入库后修改这个字段
  def in_stored_display
    self.in_stored? ? 'Y' : 'N'
  end

  def self.condition_search params
    if params[:group_condition].blank?
      items = InventoryListItem.where(params[:where_condition])
    else
      items = InventoryListItem.where(params[:where_condition]).group(params[:group_condition])
    end
    items
  end

  def self.condition_items params
    msg=Message.new
    msg.result = false

    items = InventoryListItem.where(inventory_list_id: params[:inventory_list_id], position: params[:position]).order(updated_at: :desc).offset(params[:page].to_i * params[:size].to_i).limit(params[:size].to_i)

    records = []
    items.each_with_index do |item, index|
      record = {}
      record[:id] = item.id
      record[:part_id] = item.part_id
      record[:part_nr]= item.part.blank? ? '' : item.part.nr
      record[:package_id] = item.package_id
      record[:qty] = item.qty
      record[:fifo] = item.fifo.blank? ? '' : item.fifo.localtime.strftime('%Y-%m-%d')
      record[:position_id] = item.position
      record[:position_nr] = item.position_nr
      record[:whouse_id] = item.whouse_id
      record[:whouse_nr] = item.whouse.blank? ? '' : item.whouse.nr
      records[index] = record
    end

    msg.result = true # if records.length>0
    msg.content = records

    return msg
  end

  def self.condition_positions params
    msg=Message.new
    msg.result = true

    if params[:position]
      items = InventoryListItem.where(position: params[:position], inventory_list_id: params[:inventory_list_id]).group(:position).select('*, count(*) as count').order(updated_at: :desc).offset(params[:page].to_i * params[:size].to_i).limit(params[:size].to_i)
    else
      items = InventoryListItem.where(inventory_list_id: params[:inventory_list_id]).group(:position).select('*, count(*) as count').order(updated_at: :desc).offset(params[:page].to_i * params[:size].to_i).limit(params[:size].to_i)
    end

    record = []
    items.each_with_index do |item, index|
      record[index] = {position_nr: item.position_nr, position_id: item.position, count: item.count}
    end

    msg.content = record

    return msg
  end

  def self.search_condition_positions params
    msg=Message.new
    msg.result = false

    items = InventoryListItem.where(position: params[:position], inventory_list_id: params[:inventory_list_id]).group(:position).select('*, count(*) as count').order(updated_at: :desc)

    record = []
    items.each_with_index do |item, index|
      record[index] = {position_nr: item.position_nr, position_id: item.position, count: item.count}
    end

    # records = []
    # items.each_with_index do |item, index|
    #   record = {}
    #   record[:id] = item.id
    #   record[:part_id] = item.part_id
    #   record[:package_id] = item.package_id
    #   record[:qty] = item.qty
    #   record[:fifo] = item.fifo.blank? ? '' : item.fifo.localtime.strftime('%Y-%m-%d')
    #   record[:position] = item.position
    #   record[:whouse_id] = item.whouse_id
    #   records[index] = record
    # end

    msg.result = true if record.length>0
    msg.content = record

    return msg
  end
end
