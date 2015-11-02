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

  whouse=Whouse.new(id: 'TransWhouse', name: '在途库')
  whouse.location=Location.find_by_id('Basic')
  whouse.save
  unless user=User.find_by_id('admin')
    user = User.create({id: 'admin',name: 'Admin', location_id: l.id, password: '123456@', password_confirmation: '123456@', role_id: 100, is_sys: true,user_name:'admin'})
  end

  # init package label regex
  unless Regex.where(code: 'UNIQ', type: RegexType::PACKAGE_LABEL).first
    Regex.create(name: '唯一码', code: 'UNIQ', prefix_string: 'WI', regex_string: '^WI\w+', type: RegexType::PACKAGE_LABEL)
  end
  unless Regex.where(code: 'PART', type: RegexType::PACKAGE_LABEL).first
    Regex.create(name: '零件号', code: 'PART', prefix_string: 'P', regex_string: '^P\w+', type: RegexType::PACKAGE_LABEL)
  end
  #unless Regex.where(code: 'PART_TRIM', type: RegexType::PACKAGE_LABEL).first
  #  Regex.create(name: '零件号截断', code: 'PART_TRIM',   regex_string: '^P', type: RegexType::PACKAGE_LABEL)
  #end
  unless Regex.where(code: 'QUANTITY', type: RegexType::PACKAGE_LABEL).first
    Regex.create(name: '数量', code: 'QUANTITY', prefix_string: 'Q', regex_string: '^Q\d+\.?\d*$', type: RegexType::PACKAGE_LABEL)
  end
  #unless Regex.where(code: 'QUANTITY_TRIM', type: RegexType::PACKAGE_LABEL).first
  #  Regex.create(name: '数量截断', code: 'QUANTITY_TRIM',regex_string: '^Q', type: RegexType::PACKAGE_LABEL)
  #end
  unless Regex.where(code: 'DATE', type: RegexType::PACKAGE_LABEL).first
    Regex.create(name: '入库时间', code: 'DATE', prefix_string: 'W  ', regex_string: '^W\s*\S+', remark: 'W后有两个空格，请认真检测标签', type: RegexType::PACKAGE_LABEL)
  end
  #unless Regex.whercode: 'DATE_TRIM', type: RegexType::PACKAGE_LABEL).first
  #  Regex.create(name: '入库时间截断', code: 'DATE_TRIM',  regex_string: '^W', type: RegexType::PACKAGE_LABEL)
  #end
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
  unless SysConfig.find_by_code('PRINT_SERVER')
    SysConfig.create(code: 'PRINT_SERVER', value: 'http://192.168.8.77:9000', name: '打印服务器地址')
  end
  unless SysConfig.find_by_code('PRINT_ACTION')
    SysConfig.create(code: 'PRINT_ACTION', value: '/printer/print/', name: '打印方法')
  end

  unless SysConfig.find_by_code('IOS_VERSION')
    SysConfig.create(code: 'IOS_VERSION', value: '0.1', name: 'IOS版本号')
  end

  unless SysConfig.find_by_code('IS_FORCE')
    SysConfig.create(code: 'IS_FORCE', value: false, name: '是否强制更新')
  end

  unless SysConfig.find_by_code('TRANS_WAREHOUSE')
    SysConfig.create(code: 'TRANS_WAREHOUSE', value: 'ITLZ', name: '在途库编号')
  end

  unless SysConfig.find_by_code('LED_SERVICE_PORT')
    SysConfig.create(code: 'LED_SERVICE_PORT', value: '9001', name: 'LED服务端口')
  end
  unless SysConfig.find_by_code('LED_SEND_MSG_ACTION')
    SysConfig.create(code: 'LED_SEND_MSG_ACTION', value: '/led/message/send/', name: 'LED服务发送消息方法')
  end

  unless SysConfig.find_by_code('LED_ENABLE')
    SysConfig.create(code: 'LED_ENABLE', value: 'false', name: '是否开启LED')
  end

  unless SysConfig.find_by_code('DEFAULT_WAREHOUSE')
    SysConfig.create(code: 'DEFAULT_WAREHOUSE', value: '3EX', name: '默认仓库号')
  end

  unless SysConfig.find_by_code('INVENTORY_ENABLE')
    SysConfig.create(code: 'INVENTORY_ENABLE', value: 'false', name: '是否开启盘点模式')
  end


  #LED STATE
  unless LedState.find_by_state(LedLightState::NORMAL)
    LedState.create({state: LedLightState::NORMAL, rgb: "0 255 0", led_code: 0})
  end
  unless LedState.find_by_state(LedLightState::ORDERED)
    LedState.create({state: LedLightState::ORDERED, rgb: "255 0 0", led_code: 1})
  end
  unless LedState.find_by_state(LedLightState::DELIVERED)
    LedState.create({state: LedLightState::DELIVERED, rgb: "0 0 255", led_code: 2})
  end
  unless LedState.find_by_state(LedLightState::RECEIVED)
    LedState.create({state: LedLightState::RECEIVED, rgb: "0 255 0", led_code: 0})
  end

  l = Location.create({id: 'FG', name: '成品仓库', is_base: false}) unless (l=Location.find_by_id('FG'))
  unless Whouse.find_by_id('FW87')
    whouse=Whouse.new(id: 'FW87', name: '成品在途库')
    whouse.location=l
    whouse.save
  end
  unless  User.find_by_id('PACK_SYS_USER')
    User.create({id: 'PACK_SYS_USER', name: 'PACK_SYS_USER',
                 location_id: l.id, password: '123456@',
                 password_confirmation: '123456@', role_id: 100, is_sys: true})
  end

  # api v3
  MoveType.create!([{typeId: 'MOVE', short_desc: 'move type'},
                   {typeId: 'ENTRY', short_desc: 'entey'}])

end
