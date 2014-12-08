count = 0
User.all.each do |u|
  if u.user_name.nil?
    u.update({user_name: u.id})
    count+=1
  end
end
puts count.to_s+"个User被更新"

Location.all.each do |l|
  if l.destination_id
    ld = l.location_destinations.build({location_id:l.id,destination_id:l.destination_id,is_default:true})
    ld.save
    puts "-----------------"
    puts ld.destination.name
  end
end

RegexType.types.each do |type|
  rc=RegexCategory.new(name: RegexType.display(type), type: type)
  Regex.where(type: type).each do |r|
    rc.regexes<<r
  end
  rc.save
end