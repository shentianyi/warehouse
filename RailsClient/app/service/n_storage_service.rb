class NStorageService


  def self.get_positions part_id
    positions=[]

    storages=NStorage.where(partNr: part_id).group("position_id")
    storages.each do |storage|
      if p=Position.find_by_id(storage.position_id)
        positions<<p.nr
      end
    end
    positions.join(';')
  end

  def self.get_total_stock part_id
    if storages=NStorage.select("SUM(n_storages.qty) as total").where(partNr: part_id)
      storages.first.total
    else
      0
    end
  end

end