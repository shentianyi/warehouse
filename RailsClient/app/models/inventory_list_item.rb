class InventoryListItem < ActiveRecord::Base
  #belongs_to :package
  #belongs_to :part
  # belongs_to :position
  #belongs_to :user
  belongs_to :inventory_list

  validates :qty, :inventory_list_id, presence: true
  validates_inclusion_of :in_store, in: [true, false]

  def self.new_item(package_id, unique_id, part_id, qty, position, inventory_list_id, user_id)
    query = NStorage.new

    # 根据参数组合情况获取nstorage start
    if !package_id.blank?
      if InventoryListItem.where(package_id: package_id, inventory_list_id: inventory_list_id).first
        raise '已盘点'
      end
      query = NStorage.where("packageid = :packageid ", {:packageid => package_id}).first
    elsif !unique_id.blank?
      query = NStorage.where("uniqueid = :uniqueid ", {:uniqueid => unique_id}).first
    elsif !part_id.blank? && !position.blank?
      query=nil
    else
      query = nil
    end
    # 根据参数组合情况获取nstorage end


    # 已入库，参数组合生成
    if query.nil?
      current_whouse = nil
      current_position = nil
      in_store = false
    else
      current_whouse = query.ware_house_id
      current_position = query.position
      in_store = true
      qty=query.qty if qty.blank?
      if part_id.blank?
        part_id = query.partNr
      end
    end

    # 存在nstorage记录，且传入part_id为nil则使用nstorage的partNr，否则默认使用传入的part_id
    # 赋值
    inventory_list_item = InventoryListItem.new(:package_id => package_id, :unique_id => unique_id,
                                                :part_id => part_id, :qty => qty, :position => position, :current_whouse => current_whouse,
                                                :current_position => current_position, :user_id => user_id, :in_store => in_store,
                                                :inventory_list_id => inventory_list_id)
    puts inventory_list_item.to_json
    # 保存
    if inventory_list_item.save!
      return inventory_list_item
    else

      return nil
    end

  end

end
