#现有库存 A
#盘点入库库存 B
#移入库存 C
#移出库存 D
#A=B+C-D

condition={}
condition[:created_at]=Time.parse('2015-12-12 00:00:00').utc.to_s...Time.parse('2016-04-29 11:38:44').utc.to_s

NStorage.transaction do
  storages=NStorage.where(ware_house_id: ["3EX", "SR01"])
               .select("SUM(n_storages.qty) as total_qty, n_storages.*")
               .group(:partNr, :ware_house_id, :position)
  storages.each do |storage|

    b=c=d=0

    if storage.position.blank?
      #B
      b=Movement.where(partNr: storage.partNr, type_id: 2, to_id: storage.ware_house_id)
            .where(" toPosition is null")
            .where(condition)
            .select("SUM(movements.qty) as entry_qty").first.entry_qty.to_f

      #C
      c=Movement.where(partNr: storage.partNr, type_id: 1, to_id: storage.ware_house_id)
            .where(" toPosition is null")
            .where(" from_id != ? AND fromPosition is not null", storage.ware_house_id)
            .where(condition)
            .select("SUM(movements.qty) as move_in_qty").first.move_in_qty.to_f

      #D
      d=Movement.where(partNr: storage.partNr, type_id: 1, from_id: storage.ware_house_id)
            .where(" fromPosition is null")
            .where(" to_id != ? AND toPosition is not null", storage.ware_house_id)
            .where(condition)
            .select("SUM(movements.qty) as move_out_qty").first.move_out_qty.to_f
    else
      #B
      b=Movement.where(partNr: storage.partNr, type_id: 2, to_id: storage.ware_house_id, toPosition: storage.position)
            .where(condition)
            .select("SUM(movements.qty) as entry_qty").first.entry_qty.to_f

      #C
      c=Movement.where(partNr: storage.partNr, type_id: 1, to_id: storage.ware_house_id, toPosition: storage.position)
            .where(" movements.from_id != ? ", storage.ware_house_id)
            .where(" movements.fromPosition != ? or movements.fromPosition is null ", storage.position)
            .where(condition)
            .select("SUM(movements.qty) as move_in_qty").first.move_in_qty.to_f

      #D
      d=Movement.where(partNr: storage.partNr, type_id: 1, from_id: storage.ware_house_id, fromPosition: storage.position)
            .where(" movements.to_id != ?", storage.ware_house_id)
            .where(" movements.toPosition != ? or movements.toPosition is null ", storage.position)
            .where(condition)
            .select("SUM(movements.qty) as move_out_qty").first.move_out_qty.to_f

    end

    calc_storage_qty=b + c - d
    unless storage.total_qty==calc_storage_qty
      qty=storage.qty.to_f-storage.total_qty.to_f+calc_storage_qty
      storage.update_attributes(qty: qty)
    end
  end
end
