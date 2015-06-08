class NStorage < ActiveRecord::Base
  belongs_to :ware_house, class_name: 'WareHouse'

  def whId
    ware_house and ware_house.whId or nil
  end
  
  def self.generate_diff_report(inventory_list_id)
    condition = {}
    condition['inventory_list_items.inventory_list_id']= inventory_list_id
    # NStorage.joins("LEFT JOIN inventory_list_items ON inventory_list_items.part_id = n_storages.partNr")
#             .where(condition)
#             .select("n_storages.partNr, sum(n_storages.qty) as qty, sum(inventory_list_items.qty) as qty2, sum(n_storages.qty)-sum(inventory_list_items.qty) as diff")
#             .group('n_storages.partNr')
    results = [] 
    resultstemp = []       
    @storages = NStorage
            .select("partNr, sum(qty) as qty ")
            .group('partNr')
            
    @inventory_list_items = InventoryListItem
            .where(condition)
            .select("part_id, sum(qty) as qty2 ")
            .group("part_id")
    
    @storages.each do |storage|
      # puts "#{storage.partNr}"
      results.push([storage.partNr, storage.qty, 0, storage.qty]) 
    end

    @inventory_list_items.each do |inventory_list_item|
        @flag = false
        results.each do |result|
        # @storages.each do |storage|
          if inventory_list_item.part_id.to_s == result[0].to_s
            result.insert(2,inventory_list_item.qty2)
            result[3] = result[1] -  result[2]
            @flag = true
            # break
          end

        end
        if !@flag
          results.push([inventory_list_item.part_id.to_s, 0, inventory_list_item.qty2, 0-inventory_list_item.qty2.to_f]) 
          #puts "part id is -- #{inventory_list_item.part_id}"
        end
        
        
    end
    return results
  end
   
end
