NStorage.transaction do
  NStorage.where("packageId like 'WI%'").delete_all
  Movement.where("packageId like 'WI%'").delete_all

  LogisticsContainer.uniq.joins(:package).each do |lc|
    lc.enter_store
  end
end