class StorageService

  def self.get_mrp_part_stock_by_nrs part_nrs
    get_part_stock_by_nrs(part_nrs,Whouse.mrp_whouses)
  end

  def self.get_part_stock_by_nrs part_nrs,whouses=nil
   q= NStorage.where(partNr: part_nrs)
    if whouses.present?
      q=q.where(ware_house_id: whouses.pluck(:id))
    end
    q.joins('inner join parts on n_storages.partNr=parts.id').group(:partNr)
        .select('sum(n_storages.qty) as qty,n_storages.fifo,n_storages.partNr,parts.unit')
  end
end