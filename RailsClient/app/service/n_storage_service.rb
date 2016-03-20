class NStorageService


  def self.get_positions part_id, location
    positions=[]

    ids= NStorage.where(partNr: part_id,
                        ware_house_id: (location.whouses.pluck(:id)-[location.send_whouse.id])).pluck(:position_id).uniq
    ids.each do |id|
      if p=Position.find_by_id(id)
        positions<<p.nr
      end
    end
    positions.join(';')
  end

  def self.get_total_stock_count part_id, location
    # if storage=NStorage.select("SUM(n_storages.qty) as total").where(partNr: part_id).first
    #   storage.total
    # else
    #   0
    # end

    NStorage.where(partNr: part_id,
                   ware_house_id: (location.whouses.pluck(:id)-[location.send_whouse.id])).count
  end


end