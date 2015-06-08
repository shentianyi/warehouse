class InventoryListItem < ActiveRecord::Base
  #belongs_to :package
  #belongs_to :part
  # belongs_to :position
  #belongs_to :user
  belongs_to :inventory_list
  
  validates :part_id, :qty, :inventory_list_id, presence: true
  validates_inclusion_of :in_store, in: [true, false]
  
  def self.new_item(package_id, unique_id, part_id, qty, position, inventory_list_id, user_id)
    query = NStorage.new
    
    # 根据参数组合情况获取nstorage start
    if !package_id.blank?
      query = NStorage.where("packageid = :packageid ",{:packageid => package_id})
    elsif !unique_id.blank?
      query = NStorage.where("uniqueid = :uniqueid ",{:uniqueid => unique_id})
    elsif !part_id.blank? && !part_id.blank?
      # query = NStorage.find_by(partNr: params[:part_id])
      query = NStorage.where("partNr = :partNr and position = :position",
        {:partNr => part_id, :position => position})
    else
      query = nil
    end
    # 根据参数组合情况获取nstorage end
    
    if query.blank? 
      # 未入库，直接生成
      current_whouse = nil
      current_position = nil
      in_store = false
    else
      # 已入库，参数组合生成
      puts "#{query.count}asdfsadfquery.count"
      if query.count != 1
        current_whouse = nil
        current_position = nil
        in_store = false
      else
        current_whouse = query[0].ware_house_id
        current_position = query[0].position
        in_store = true
      end
      
      # 存在nstorage记录，且传入qty为nil则使用nstorage的qty，否则默认使用传入的qty
      if qty.blank?
        qty = query[0].qty
      end
      
      # 存在nstorage记录，且传入part_id为nil则使用nstorage的partNr，否则默认使用传入的part_id
      if part_id.blank?
        part_id = query[0].partNr
      end
      
    end
    
    # 赋值
    inventory_list_item = InventoryListItem.new(:package_id => package_id,:unique_id => unique_id,
    :part_id => part_id,:qty => qty,:position => position,:current_whouse => current_whouse,
    :current_position => current_position,:user_id => user_id,:in_store => in_store,
    :inventory_list_id => inventory_list_id)
    
    # 保存
    if inventory_list_item.save
      return inventory_list_item
    else
      return nil
    end
    
  end
  
end
