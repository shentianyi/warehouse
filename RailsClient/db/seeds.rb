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

  t=Tenant.create(name: '上海佳轩物流有限公司', code: 'SHJX', short_name: '简称', type: TenantType::SELF)

  # init location and admin
  l = Location.create(nr: 'Default', name: 'Default Location', is_base: true, tenant_id: t.id) unless (l=Location.find_by_id('Default'))

  unless user=User.find_by_id('admin')
    user = User.create({name: 'Admin', location_id: l.id,
                        password: '123456@',
                        password_confirmation: '123456@', role_id: 100, is_sys: true, nr: 'admin'})
  end

  # init package label regex
  unless Regex.where(code: 'UNIQ', type: RegexType::PACKAGE_LABEL).first
    Regex.create(name: '唯一码', code: 'UNIQ', prefix_string: 'WI', regex_string: '^WI\w+', type: RegexType::PACKAGE_LABEL)
  end
  unless Regex.where(code: 'PART', type: RegexType::PACKAGE_LABEL).first
    Regex.create(name: '零件号', code: 'PART', prefix_string: 'P', regex_string: '^P\w+', type: RegexType::PACKAGE_LABEL)
  end

  unless Regex.where(code: 'QUANTITY', type: RegexType::PACKAGE_LABEL).first
    Regex.create(name: '数量', code: 'QUANTITY', prefix_string: 'Q', regex_string: '^Q\d+\.?\d*$', type: RegexType::PACKAGE_LABEL)
  end

  unless Regex.where(code: 'DATE', type: RegexType::PACKAGE_LABEL).first
    Regex.create(name: '入库时间', code: 'DATE', prefix_string: 'W  ', regex_string: '^W\s*\S+', remark: 'W后有两个空格，请认真检测标签', type: RegexType::PACKAGE_LABEL)
  end

  unless Regex.where(code: 'ORDERITEM_PART', type: RegexType::ORDERITEM_LABEL).first
    Regex.create(name: '需求单零件号', code: 'ORDERITEM_PART', prefix_string: 'P', regex_string: '^P\w+', type: RegexType::ORDERITEM_LABEL)
  end

  unless Regex.where(code: 'ORDERITEM_QTY', type: RegexType::ORDERITEM_LABEL).first
    Regex.create(name: '需求单数量', code: 'ORDERITEM_QTY', prefix_string: 'Q', regex_string: '^Q\d+\.?\d*$', type: RegexType::ORDERITEM_LABEL)
  end

  unless Regex.where(code: 'ORDERITEM_DEPARTMENT', type: RegexType::ORDERITEM_LABEL).first
    Regex.create(name: '需求部门', code: 'ORDERITEM_DEPARTMENT', prefix_string: 'LO', regex_string: '^LO\w+', type: RegexType::ORDERITEM_LABEL)
  end

  # init system config
  # 数据配置
  unless SysConfig.find_by_code('WEB_SHOW_CLIENT_PART_NR')
    SysConfig.create(code: 'WEB_SHOW_CLIENT_PART_NR', category: '数据配置', index: 300, value: 'SHL', name: '网页显示客户零件号', description: '填写客户编码，多个以英文字逗号分隔')
  end

  unless SysConfig.find_by_code('APP_SHOW_RECENT_DATA_DAYS')
    SysConfig.create(code: 'APP_SHOW_RECENT_DATA_DAYS', category: '数据配置', index: 300, value: '2', name: 'APP查看几天前数据', description: '填写数字，大于0的整数')
  end


  # 盘点配置
  unless SysConfig.find_by_code('INVENTORY_ENABLE')
    SysConfig.create(code: 'INVENTORY_ENABLE', category: '盘点配置', index: 900, value: 'false', name: '是否开启盘点模式')
  end

  unless SysConfig.find_by_code('HIDE_FINISHED_INVENTORY')
    SysConfig.create(code: 'HIDE_FINISHED_INVENTORY', category: '盘点配置', index: 900, value: 'true', name: '是否隐藏结束的盘点单')
  end


  # 打印服务配置
  unless SysConfig.find_by_code('PRINT_SERVER')
    SysConfig.create(code: 'PRINT_SERVER', value: 'http://192.168.8.77:9000', category: '打印服务配置', index: 1000, name: '打印服务器地址')
  end

  #佳轩扩展配置
  unless SysConfig.find_by_code('JIAXUAN_EXTRA_SOURCE')
    SysConfig.create(code: 'JIAXUAN_EXTRA_SOURCE', value: l.nr, category: '佳轩扩展配置', index: 1200, name: '发运地址')
  end

  unless SysConfig.find_by_code('JIAXUAN_EXTRA_DESTINATION')
    SysConfig.create(code: 'JIAXUAN_EXTRA_DESTINATION', value: l.nr, category: '佳轩扩展配置', index: 1200, name: '接收地址')
  end

  unless SysConfig.find_by_code('JIAXUAN_EXTRA_SH_CUSTOM')
    SysConfig.create(code: 'JIAXUAN_EXTRA_SH_CUSTOM', value: Tenant.first.code, category: '佳轩扩展配置', index: 1300, name: '上海客户编码')
  end

  unless SysConfig.find_by_code('JIAXUAN_EXTRA_CZ_CUSTOM')
    SysConfig.create(code: 'JIAXUAN_EXTRA_CZ_CUSTOM', value: Tenant.last.code, category: '佳轩扩展配置', index: 1300, name: '常州客户编码')
  end


  # api v3
  MoveType.create!([{typeId: 'MOVE', short_desc: 'move type'},
                    {typeId: 'ENTRY', short_desc: 'entey'}])

end
