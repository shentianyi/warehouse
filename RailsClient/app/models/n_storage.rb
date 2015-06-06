class NStorage < ActiveRecord::Base
  belongs_to :ware_house, class_name: 'WareHouse'

  def whId
    ware_house and ware_house.whId or nil
  end
  
  def self.generate_diff_report(inventory_list_id)
    condition = {}
    condition['inventory_list_items.inventory_list_id']= inventory_list_id
    NStorage.joins("LEFT JOIN inventory_list_items ON inventory_list_items.part_id = n_storages.partNr")
            .where(condition)
            .select("n_storages.partNr, sum(n_storages.qty) as qty, sum(inventory_list_items.qty) as qty2, sum(n_storages.qty)-sum(inventory_list_items.qty) as diff")
            .group('n_storages.partNr')
  end
end
