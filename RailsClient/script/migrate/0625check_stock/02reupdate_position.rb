Position.transaction do
  Position.all.each do |position|
    puts "update: #{position.id}---#{position.detail}"
    NStorage.where(position: position.id).update_all(position: position.detail)
    Movement.where(fromPosition: position.id).update_all(fromPosition: position.detail)
    Movement.where(toPosition: position.id).update_all(toPosition: position.detail)
  end
end