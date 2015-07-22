class InventoryListItem < ActiveRecord::Base
  #belongs_to :package
  #belongs_to :part
  # belongs_to :position
  #belongs_to :user
  belongs_to :inventory_list

  validates :qty, :inventory_list_id, presence: true
  validates_inclusion_of :in_store, in: [true, false]

  def self.new_item(params)
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
      query=nil
    else
      query = nil
    end
    # 根据参数组合情况获取nstorage end

    # 已入库，参数组合生成
    if query.nil?
      params[:current_whouse] = nil
      params[:current_position] = nil
      params[:in_store] = false
    else
      params[:current_whouse] = query.ware_house_id
      params[:current_position] = query.position
      params[:in_store] = true
      params[:fifo]=query.fifo
      params[:origin_qty] =params[:qty]=query.qty if params[:qty].blank?
      if params[:part_id].blank?
        params[:part_id] = query.partNr
      end
    end

    part=Part.find_by_id(params[:part_id])
    if params[:need_convert]
      params[:qty]=BigDecimal.new(params[:origin_qty].to_s)/BigDecimal.new(part.convert_unit.to_s)
    else
      params[:qty]=BigDecimal.new(params[:origin_qty].to_s)
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
    params={
        partNr: self.part_id,
        qty: self.qty,
        fifo: self.fifo.present? ? self.fifo : nil,
        packageId: self.package_id.present? ? self.package_id : nil,
        toWh: self.whouse_id.present? ? self.whouse_id : nil,
        toPosition: self.position.present? ? self.position : nil,
        uniq: true
    }
    puts '--------------------------------------'
    puts params.to_json
    puts '--------------------------------------'
    WhouseService.new.enter_stock(params)
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

  def in_stored_display
    self.in_stored? ? 'Y' : 'N'
  end
end
