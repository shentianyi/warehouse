InventoryListItem.transaction do
  InventoryListItem.where(fifo: nil).where("package_id<>''").each do |item|
    puts item.to_json
    if storage=NStorage.where(packageId: item.package_id).first
      puts "##{item.package_id}"
      item.update_attributes(fifo: storage.fifo)
    end
  end
end