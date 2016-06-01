NStorage.transaction do
  wh=Whouse.find_by_nr('CZSend')
  NStorage.where(ware_house_id: wh.id).each do |storage|
    storage.destroy
  end
end