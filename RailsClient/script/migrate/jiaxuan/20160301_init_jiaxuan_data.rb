ActiveRecord::Base.transaction do

  # unless t=Tenant.find_by_code('SHJX')
  #   t=Tenant.create(name: '上海佳轩物流有限公司', code: 'SHJX', short_name: '上海佳轩简称', type: TenantType::SELF)
  # end

  unless t=Tenant.find_by_code('JXJX')
    t=Tenant.create(name: '江西佳轩物流有限公司', code: 'JXJX', short_name: '江西佳轩简称', type: TenantType::SELF)
  end

  
  # init location and admin
  # unless (jxlo=Location.find_by_nr('SHJXLO'))
  #   jxlo = Location.create(nr: 'SHJXLO', name: '上海佳轩物流', is_base: true,
  #                          tenant_id: t.id,
  #                          address: '上海佳轩物流有限公司的地址',
  #                          receive_mode: DeliveryReceiveMode::PACKAGE)
  # end

  unless (jxlo=Location.find_by_nr('JXJXLO'))
    jxlo = Location.create(nr: 'JXJXLO', name: '江西佳轩简称', is_base: true,
                           tenant_id: t.id,
                           address: '江西佳轩物流有限公司的地址',
                           receive_mode: DeliveryReceiveMode::PACKAGE)
  end

  unless user=User.find_by_nr('admin')
    user = User.create({name: 'Admin', location_id: jxlo.id,
                        password: '123456@',
                        password_confirmation: '123456@', role_id: 100, is_sys: true, nr: 'admin'})
  end

  # init client
  unless shl=Tenant.find_by_code('SHL')
    shl=Tenant.create(name: '上海莱尼电器有限公司', code: 'SHL', short_name: '上海莱尼')
  end

  unless czl=Tenant.find_by_code('CZL')
    czl=Tenant.create(name: '常州莱尼线束有限公司', code: 'CZL', short_name: '常州莱尼')
  end

  # init location
  unless (shllo=Location.find_by_nr('SHLLO'))
    shllo = Location.create(nr: 'SHLLO', name: '上海莱尼', is_base: true,
                            tenant_id: shl.id,
                            address: '上海莱尼电器有限公司的地址',
                            receive_mode: DeliveryReceiveMode::FORKLIFT,
                            order_source_location_id:jxlo.id)
  end

  unless (czllo=Location.find_by_nr('CZLLO'))
    czllo = Location.create(nr: 'CZLLO', name: '常州莱尼', is_base: true,
                            tenant_id: czl.id,
                            address: '常州莱尼线束有限公司的地址')
  end

  # set as destination
  unless ps= jxlo.location_destinations.where(destination_id: shllo.id).first
    jxlo.add_destination(shllo)
  end
  unless czllo.location_destinations.where(destination_id: jxlo.id).first
    czllo.add_destination(jxlo)
  end


  # init warehouse
  # jx receive warehouse
  unless rw=Whouse.find_by_nr('JXReceive')
    rw=jxlo.whouses.create(nr: 'JXReceive', name: '佳轩接收仓库')
  end
  # send warehouse
  unless sw=Whouse.find_by_nr('JXSend')
    sw=jxlo.whouses.create(nr: 'JXSend', name: '佳轩在途仓库')
  end

  jxlo.receive_whouse=rw
  jxlo.send_whouse=sw
  jxlo.save

  # cz send warehouse
  unless czsw=Whouse.find_by_nr('CZSend')
    czsw=czllo.whouses.create(nr: 'CZSend', name: '常州莱尼在途仓库')
  end
  czllo.send_whouse=czsw
  czllo.save

  # sh receive warehouse
  unless shrw=Whouse.find_by_nr('SHReceive')
    shrw=shllo.whouses.create(nr: 'SHReceive', name: '上海莱尼接收仓库')
  end

  shllo.receive_whouse=shrw
  shllo.save



  #佳轩扩展配置
  unless SysConfig.find_by_code('JIAXUAN_EXTRA_SOURCE')
    SysConfig.create(code: 'JIAXUAN_EXTRA_SOURCE', value: czllo.nr, category: '佳轩扩展配置', index: 1200, name: '发运地址')
  end

  unless SysConfig.find_by_code('JIAXUAN_EXTRA_SH_CUSTOM')
    SysConfig.create(code: 'JIAXUAN_EXTRA_SH_CUSTOM', value: shl.code,category: '佳轩扩展配置', index: 1300, name: '上海客户编码')
  end

  unless SysConfig.find_by_code('JIAXUAN_EXTRA_CZ_CUSTOM')
    SysConfig.create(code: 'JIAXUAN_EXTRA_CZ_CUSTOM', value: czl.code, category: '佳轩扩展配置', index: 1300, name: '常州客户编码')
  end


end
