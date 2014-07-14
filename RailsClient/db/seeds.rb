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

  # init location and admin
  l = Location.create({id: 'Basic', name: 'Basic Location', is_base: true}) unless (l=Location.find_by_id('Basic'))
  unless user=User.find_by_id('admin')
    user = User.create({id: 'admin', name: 'Admin', location_id: l.id, password: '123456@', password_confirmation: '123456@', role_id: 100, is_sys: true})
  end

  # init package label regex
  unless Regex.where(code: 'UNIQ', type: RegexType::PACKAGE_LABEL).first
    Regex.create(name: '唯一码', code: 'UNIQ', prefix_string: 'WI', regex_string: '^WI\d*$', type: RegexType::PACKAGE_LABEL)
  end
  unless Regex.where(code: 'PART', type: RegexType::PACKAGE_LABEL).first
    Regex.create(name: '零件号', code: 'PART', prefix_string: 'P', regex_string: '^P', type: RegexType::PACKAGE_LABEL)
  end
  unless Regex.where(code: 'QUANTITY', type: RegexType::PACKAGE_LABEL).first
    Regex.create(name: '数量', code: 'QUANTITY', prefix_string: 'Q', regex_string: '^Q? ?\d*\.?\d*$', type: RegexType::PACKAGE_LABEL)
  end
  unless Regex.where(code: 'DATE', type: RegexType::PACKAGE_LABEL).first
    Regex.create(name: '入库时间', code: 'DATE', prefix_string: 'W', regex_string: '^W', type: RegexType::PACKAGE_LABEL)
  end
end