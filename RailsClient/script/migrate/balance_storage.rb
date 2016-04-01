#现有库存 A
#盘点入库库存 B
#移入库存 C
#移出库存 D
#A=B+C-D
p Time.now
condition={}
condition[:created_at]=Time.parse('2015-12-12 00:00:00').utc.to_s...Time.parse('2016-03-29 11:38:44').utc.to_s

count=0
NStorage.transaction do
  #ck ["3EX", "3PL", "BaofeiKu", "CUTTING_TMP", "KehuKu", "P82", "PA82", "Sample_tmp", "SR01", "SRPL", "误操作库", "转移老厂半成品"]
  storages=NStorage.where(ware_house_id: ["3EX", "3PL", "BaofeiKu", "CUTTING_TMP", "KehuKu", "P82", "PA82", "Sample_tmp", "SR01", "SRPL", "误操作库", "转移老厂半成品"])
               .select("SUM(n_storages.qty) as total_qty, n_storages.*")
               .group(:partNr, :ware_house_id, :position)
  # storages=NStorage.where(ware_house_id: 'SR01', position: 'SR01', partNr: '76755104W000')
  #              .select("SUM(n_storages.qty) as total_qty, n_storages.*")
  #              .group(:partNr, :ware_house_id, :position)
  storages.each do |storage|
    count+=1
    puts "-----#{count}-----"
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
    # puts "- #{b}-------- #{c} ------------ #{d} -------------(#{storage.qty.to_f})-------"

    calc_storage_qty=b + c - d
    unless storage.total_qty==calc_storage_qty
      qty=storage.qty.to_f-storage.total_qty.to_f+calc_storage_qty
      # puts "update #{qty}"
      storage.update_attributes(qty: qty)
      # p storage
    end
  end
end


p Time.now


# NStorage.transaction do
#   storages=NStorage.select("SUM(n_storages.qty) as total_qty, n_storages.*").group(:partNr, :ware_house_id, :position)
#   storages.each do |storage|
#     count+=1
#     puts "--------------------------------------#{count}---------------------------------------------"
#
#     if storage.position.blank?
#       #B
#       b=Movement.where(partNr: storage.partNr, type_id: 2, to_id: storage.ware_house_id)
#             .where(" toPosition is null")
#             .where(condition)
#             .select("SUM(movements.qty) as entry_qty, movements.*").first
#
#       #C
#       c=Movement.where(partNr: storage.partNr, type_id: 1, to_id: storage.ware_house_id)
#             .where(" toPosition is null")
#             .where(" from_id != ? AND fromPosition is not null", storage.ware_house_id)
#             .where(condition)
#             .select("SUM(movements.qty) as move_in_qty, movements.*").first
#
#       #D
#       d=Movement.where(partNr: storage.partNr, type_id: 1, from_id: storage.ware_house_id)
#             .where(" fromPosition is null")
#             .where(" to_id != ? AND toPosition is not null", storage.ware_house_id)
#             .where(condition)
#             .select("SUM(movements.qty) as move_out_qty, movements.*").first
#     else
#       #B
#       b=Movement.where(partNr: storage.partNr, type_id: 2, to_id: storage.ware_house_id, toPosition: storage.position)
#             .where(condition)
#             .select("SUM(movements.qty) as entry_qty, movements.*").first
#
#       #C
#       c=Movement.where(partNr: storage.partNr, type_id: 1, to_id: storage.ware_house_id, toPosition: storage.position)
#             .where(" from_id != ? AND fromPosition != ?", storage.ware_house_id, storage.position)
#             .where(condition)
#             .select("SUM(movements.qty) as move_in_qty, movements.*").first
#
#       #D
#       d=Movement.where(partNr: storage.partNr, type_id: 1, from_id: storage.ware_house_id, fromPosition: storage.position)
#             .where(" to_id != ? AND toPosition != ?", storage.ware_house_id, storage.position)
#             .where(condition)
#             .select("SUM(movements.qty) as move_out_qty, movements.*").first
#
#     end
#
#     calc_storage_qty=b.entry_qty.to_f + c.move_in_qty.to_f - d.move_out_qty.to_f
#     # puts "#{calc_storage_qty}--------#{b.entry_qty.to_f}------------#{c.move_in_qty.to_f}-------------#{d.move_out_qty.to_f}-------"
#     unless storage.total_qty==calc_storage_qty
#       qty=storage.qty.to_f-storage.total_qty.to_f+calc_storage_qty
#       # puts "#{qty}--------#{storage.qty.to_f}----------#{storage.total_qty.to_f}------------#{calc_storage_qty}--------"
#       storage.update_attribute(:qty, qty)
#     end
#   end
# end



# #A
# NStorage.select("SUM(n_storages.qty) as total_qty, n_storages.*").where(partNr: 'p00115867', ware_house_id: 'SR01').group(:partNr, :ware_house_id, :position)
#
# #B
# Movement.select("SUM(movements.qty) as entry_qty, movements.*").where(partNr: 'p00115867', type_id: 2, to_id: 'SR01', toPosition: '').where(condition)
#
# #C
# Movement.select("SUM(movements.qty) as move_in_qty, movements.*").where(partNr: 'p00115867', type_id: 1, to_id: 'SR01', toPosition: '').where(condition)
#
# #D
# Movement.select("SUM(movements.qty) as move_out_qty, movements.*").where(partNr: 'p00115867', type_id: 1, to_id: 'SR01', toPosition: '').where(condition)


# count=0
# NStorage.transaction do
#   # storages=NStorage.where(partNr: 'p00115867', ware_house_id: 'SR01').select("SUM(n_storages.qty) as total_qty, n_storages.*").group(:partNr, :ware_house_id, :position)
#   storages=NStorage.select("SUM(n_storages.qty) as total_qty, n_storages.*").group(:partNr, :ware_house_id, :position)
#   storages.each do |storage|
#     count+=1
#     puts "--------------------------------------#{count}---------------------------------------------"
#     # p storage
#
#     if storage.position.blank?
#       #B
#       b=Movement.where(partNr: 'p00115867', type_id: 2, to_id: 'SR01')
#             .where(" toPosition is null")
#             .where(condition)
#             .select("SUM(movements.qty) as entry_qty, movements.*").first
#
#       #C
#       c=Movement.where(partNr: 'p00115867', type_id: 1, to_id: 'SR01')
#             .where(" toPosition is null")
#       .where()
#             .where(condition)
#             .select("SUM(movements.qty) as move_in_qty, movements.*").first
#
#       #D
#       d=Movement.where(partNr: 'p00115867', type_id: 1, from_id: 'SR01')
#             .where(" fromPosition is null")
#             .where(condition)
#             .select("SUM(movements.qty) as move_out_qty, movements.*").first
#     else
#       #B
#       b=Movement.where(partNr: 'p00115867', type_id: 2, to_id: 'SR01', toPosition: storage.position)
#             .where(condition)
#             .select("SUM(movements.qty) as entry_qty, movements.*").first
#
#       #C
#       c=Movement.where(partNr: 'p00115867', type_id: 1, to_id: 'SR01', toPosition: storage.position)
#             .where(condition)
#             .select("SUM(movements.qty) as move_in_qty, movements.*").first
#
#       #D
#       d=Movement.where(partNr: 'p00115867', type_id: 1, from_id: 'SR01', fromPosition: storage.position)
#             .where(condition)
#             .select("SUM(movements.qty) as move_out_qty, movements.*").first
#
#     end
#
#     calc_storage_qty=b.entry_qty.to_f + c.move_in_qty.to_f - d.move_out_qty.to_f
#     puts "#{calc_storage_qty}--------#{b.entry_qty.to_f}------------#{c.move_in_qty.to_f}-------------#{d.move_out_qty.to_f}-------"
#     unless storage.total_qty==calc_storage_qty
#       qty=storage.qty.to_f-storage.total_qty.to_f+calc_storage_qty
#       puts "#{qty}--------#{storage.qty.to_f}----------#{storage.total_qty.to_f}------------#{calc_storage_qty}--------"
#       storage.update_attribute(:qty, qty)
#     end
#   end
# end