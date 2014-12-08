Location.all.each do |l|
  if l.destination_id && (l.location_destinations.where(destination_id:l.destination_id).count == 0)
    ld = l.location_destinations.build({location_id:l.id,destination_id:l.destination_id,is_default:true})
    ld.save
    puts "-----------------"
    puts ld.destination.name
  end
end