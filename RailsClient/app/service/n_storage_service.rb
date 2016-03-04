class NStorageService

  def self.stock whouse, part
    return 0 if Whouse.find_by_id(whouse).blank? || Part.find_by_id(part).blank?
    storage=NStorage.select("SUM(n_storages.qty) as stock").where(ware_house_id: whouse, partNr: part)
    if storage.blank?
      0
    else
      storage.first.stock
    end
  end


  def self.positions whouse_id, part_id
    Position.joins(:part_positions)
        .where(part_positions:{part_id:part_id},whouse_id: whouse_id)
    #Position.joins('RIGHT OUTER JOIN storages ON positions.id = storages.position_id').where(storages: {warehouse_id: warehouse, part_id: part}).select(:nr).pluck(:nr).uniq
  end

end