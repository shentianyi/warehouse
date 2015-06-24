NStorage.transaction do
  NStorage.where("packageId like 'WI%'").delete_all
  Movement.where("packageId like 'WI%'").delete_all

  LogisticsContainer.uniq.joins(:records).joins(:package).where(state: PackageState::RECEIVED).each do |lc|
    lc.enter_stock
  end
end