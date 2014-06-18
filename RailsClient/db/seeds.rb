# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#roles = Role.create([{name: 'admin'},{name: 'manager'}])
#puts roles.to_json

#create Admin User
ActiveRecord::Base.transaction do
  l = Location.create({id:'L',name:'Basic Location',is_base:true})
  user = User.create({id:'admin',name:'Admin',location_id:l.id,password:'123456@',password_confirmation:'123456@',role_id:100})
end