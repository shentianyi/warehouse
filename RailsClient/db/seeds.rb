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

  # init package label regex
  unless Regex.where(code: 'UNIQ', type: RegexType::PACKAGE_LABEL).first
    Regex.create(name: '唯一码', code: 'UNIQ', prefix_string: 'WI', regex_string: '^(M|S)[A-Za-z0-9]+$', type: RegexType::PACKAGE_LABEL)
  end
  unless Regex.where(code: 'PART', type: RegexType::PACKAGE_LABEL).first
    Regex.create(name: '零件号', code: 'PART', prefix_string: 'P', regex_string: '^[A-Za-z0-9]+$', type: RegexType::PACKAGE_LABEL)
  end

  unless Regex.where(code: 'QUANTITY', type: RegexType::PACKAGE_LABEL).first
    Regex.create(name: '数量', code: 'QUANTITY', prefix_string: 'Q', regex_string: '^((\d+\.\d*[1-9]\d*)|(\d*[1-9]\d*\.\d+)|(\d*[1-9]\d*))$', type: RegexType::PACKAGE_LABEL)
  end

  # unless Regex.where(code: 'DATE', type: RegexType::PACKAGE_LABEL).first
  #   Regex.create(name: '入库时间', code: 'DATE', prefix_string: 'W  ', regex_string: '^W\s*\S+', remark: 'W后有两个空格，请认真检测标签', type: RegexType::PACKAGE_LABEL)
  # end

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

  #接收配置400

  # 发运配置
  unless SysConfig.find_by_code('CHECK_PACKAGE_IN_STOCK_FOR_DELIVERY')
    SysConfig.create(code: 'CHECK_PACKAGE_IN_STOCK_FOR_DELIVERY', category: '发运配置', index: 500, value: 'true', name: '强制验证包装箱是否在库存', description: '如果验证,则不在库存不可以发货')
  end

  # 盘点配置
  unless SysConfig.find_by_code('INVENTORY_ENABLE')
    SysConfig.create(code: 'INVENTORY_ENABLE', category: '盘点配置', index: 900, value: 'false', name: '是否开启盘点模式')
  end

  unless SysConfig.find_by_code('HIDE_FINISHED_INVENTORY')
    SysConfig.create(code: 'HIDE_FINISHED_INVENTORY', category: '盘点配置', index: 900, value: 'true', name: '是否隐藏结束的盘点单')
  end

  #库位容量配置
  unless SysConfig.find_by_code('POSITION_CAPACITY_SWITCH')
    SysConfig.create(code: 'POSITION_CAPACITY_SWITCH', category: '库位容量配置', index: 900, value: 'true', name: '库位容量检查开关')
  end

  unless SysConfig.find_by_code('WOODEN_POSITION_CAPACITY')
    SysConfig.create(code: 'WOODEN_POSITION_CAPACITY', category: '库位容量配置', index: 900, value: '150', name: '木盘库位容量')
  end

  unless SysConfig.find_by_code('NOMAL_POSITION_CAPACITY')
    SysConfig.create(code: 'NOMAL_POSITION_CAPACITY', category: '库位容量配置', index: 900, value: '6', name: '标准库位容量')
  end

  #物料堆放库位配置
  unless SysConfig.find_by_code('WOODEN_POSITION_CONFIG')
    SysConfig.create(code: 'WOODEN_POSITION_CONFIG', category: '物料堆放库位配置', index: 900, value: 'NO POSITION', name: '木盘物料堆放库位配置')
  end

  # 打印服务配置
  unless SysConfig.find_by_code('PRINT_SERVER')
    SysConfig.create(code: 'PRINT_SERVER', value: 'http://192.168.8.77:9000', category: '打印服务配置', index: 1000, name: '打印服务器地址')
  end


  # api v3
  MoveType.create!([{typeId: 'MOVE', short_desc: 'move type'},
                    {typeId: 'ENTRY', short_desc: 'entey'}])

end
