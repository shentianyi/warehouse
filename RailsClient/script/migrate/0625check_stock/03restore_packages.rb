NStorage.transaction do
  NStorage.where("packageId like 'WI%'").delete_all
  Movement.where("packageId like 'WI%'").delete_all

  LogisticsContainer.uniq.joins(:package).each do |lc|
    puts lc.to_json
    lc.enter_stock
  end
end