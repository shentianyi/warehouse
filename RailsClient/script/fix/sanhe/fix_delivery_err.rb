Delivery.transaction do
  destination = Location.find_by_nr('SHLLO')
  sender = User.find_by_nr('admin')

  LogisticsContainer.find_by_container_id('D161024111811').descendants.each do |l|
    l.update({state:MovableState::WAY,is_dirty:true})
    Record.update_or_create(l, {'id' => sender.id, 'type' => ImplUserType::SENDER, 'action' => __method__.to_s},destination)
  end
end