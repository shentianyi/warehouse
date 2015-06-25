class NStorage < ActiveRecord::Base
  belongs_to :ware_house, class_name: 'WareHouse'

  def whId
    ware_house and ware_house.whId or nil
  end

  def self.generate_diff_report(inventory_list_id)
    condition = {}
    condition['inventory_list_items.inventory_list_id']= inventory_list_id
    inventory_list=InventoryList.find_by_id(inventory_list_id)
    # NStorage.joins("LEFT JOIN inventory_list_items ON inventory_list_items.part_id = n_storages.partNr")
#             .where(condition)
#             .select("n_storages.partNr, sum(n_storages.qty) as qty, sum(inventory_list_items.qty) as qty2, sum(n_storages.qty)-sum(inventory_list_items.qty) as diff")
#             .group('n_storages.partNr')
    results = []
    resultstemp = []
    @storages = NStorage.
        where(ware_house_id: inventory_list.whouse_id)
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


  def self.to_total_xlsx n_storages
    p = Axlsx::Package.new

    puts "9999999999999999999999999999999999"
    wb = p.workbook
    wb.add_worksheet(:name => "sheet1") do |sheet|
      sheet.add_row ["序号", "零件号", "仓库号", "库位号", "数量", "FIFO", "包装号"]
      n_storages.each_with_index { |n_storage, index|
        if n_storage.id && n_storage.id != ""
          sheet.add_row [
                            index+1,
                            n_storage.partNr,
                            n_storage.ware_house_id,
                            n_storage.position,
                            n_storage.total_qty,
                            n_storage.fifo,
                            n_storage.packageId
                        ]
        end
      }
    end
    p.to_stream.read
  end


  def self.to_xlsx n_storages
    p = Axlsx::Package.new

    puts "9999999999999999999999999999999999"
    wb = p.workbook
    wb.add_worksheet(:name => "sheet1") do |sheet|
      sheet.add_row ["序号","零件号", "包装号",  "仓库号", "库位号", "数量", "FIFO"]
      n_storages.each_with_index { |n_storage, index|
        if n_storage.id && n_storage.id != ""
          sheet.add_row [
                            index+1,
                            n_storage.partNr,
                            n_storage.packageId,
                            n_storage.ware_house_id,
                            n_storage.position,
                            n_storage.qty,
                            n_storage.fifo
                        ]
        end
      }
    end
    p.to_stream.read
  end
end
