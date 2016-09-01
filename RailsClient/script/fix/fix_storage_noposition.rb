NStorage.transaction do
  NStorage.where(position: '').each_with_index do |storage, index|
    part=Part.find_by_id(storage.partNr)
    position=part.default_position(storage.ware_house)
    # p "#{part.id}---------#{index}---------#{storage.ware_house.id}----------#{position}"
    storage.update_attributes({position: position})
  end
end