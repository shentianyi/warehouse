User.all.each do |u|
  u.update({user_name: u.id})
end