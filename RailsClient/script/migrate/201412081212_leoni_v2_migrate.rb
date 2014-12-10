user_count = 0
User.all.each do |u|
  if u.user_name.nil?
    u.update({user_name: u.id})
    user_count+=1
  end
end
puts user_count.to_s+"个User被更新"

Location.all.each do |l|
  if l.destination_id && (l.location_destinations.where(destination_id:l.destination_id).count == 0)
    ld = l.location_destinations.build({location_id:l.id,destination_id:l.destination_id,is_default:true})
    ld.save
    puts "-----------------"
    puts ld.destination.name
  end
end

Regex.all.each{|reg|
  reg.update({id:reg.code})
}

RegexType.types.each do |type|
  if RegexCategory.where(id:type,name: RegexType.display(type), type:type).count == 0
    rc=RegexCategory.new(id:type,name: RegexType.display(type), type: type)
    Regex.where(type: type).each do |r|
      rc.regexes<<r
    end
    rc.save
  end
end

dump_pos_count = 0
update_pos_count = 0
Position.all.each do |p|
  id = "PS#{p.whouse_id}#{p.detail.gsub(/\s+/,'')}"
  if old = Position.find_by_id(id)
    dump_pos_count += 1
    old.destroy
  end

  if id != p.id
    p.update({id:id})
    update_pos_count += 1
  end
end

puts "删除了#{dump_pos_count}个重复库位!更新了#{update_pos_count}个库位!"