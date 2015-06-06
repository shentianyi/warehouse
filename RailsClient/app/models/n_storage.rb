class NStorage < ActiveRecord::Base
  belongs_to :ware_house, class_name: 'WareHouse'

  def whId
    ware_house and ware_house.whId or nil
  end
  
  def self.generate_diff_report(inventory_list_id)
    condition = {}
    condition['inventory_list_item.inventory_list_id']= inventory_list_id
    NStorage.joins("LEFT JOIN inventory_list_items ON inventory_list_items.part_id = n_storages.partNr")
            .where(condition)
            .select("distinct(n_storages.partNr), n_storages.qty, inventory_list_items.qty")
  end
end
