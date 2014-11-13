count = 0
User.all.each do |u|
  if u.user_name.nil?
    u.update({user_name: u.id})
    count+=1
  end
end
puts count.to_s+"个User被更新"