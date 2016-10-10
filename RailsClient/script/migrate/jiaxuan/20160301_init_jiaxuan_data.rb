ActiveRecord::Base.transaction do

  unless t=Tenant.find_by_code('SHJX')
    t=Tenant.create(name: '三河佳轩物流有限公司', code: 'SHJX', short_name: '三河佳轩简称', type: TenantType::SELF)
  end

  # unless t2=Tenant.find_by_code('XSJX')
  #   t2=Tenant.create(name: '萧山佳轩物流有限公司', code: 'XSJX', short_name: '萧山佳轩简称', type: TenantType::SELF)
  # end

  
  # init location and admin
  unless (jxlo=Location.find_by_nr('SHJXLO'))
    jxlo = Location.create(nr: 'SHJXLO', name: '三河佳轩物流', is_base: true,
                           tenant_id: t.id,
                           address: '三河佳轩物流有限公司的地址',
                           receive_mode: DeliveryReceiveMode::PACKAGE)
  end

  # unless (jxlo2=Location.find_by_nr('XSJXLO'))
  #   jxlo2 = Location.create(nr: 'XSJXLO', name: '萧山佳轩简称', is_base: true,
  #                          tenant_id: t2.id,
  #                          address: '萧山佳轩物流有限公司的地址',
  #                          receive_mode: DeliveryReceiveMode::PACKAGE)
  # end

  unless user=User.find_by_nr('admin')
    user = User.create({name: 'Admin', location_id: jxlo.id,
                        password: '123456@',
                        password_confirmation: '123456@', role_id: 100, is_sys: true, nr: 'admin'})
  end

  # init client
  unless hem=Tenant.find_by_code('HEM')
    hem=Tenant.create(name: '海尔曼有限公司', code: 'HEM', short_name: '海尔曼')
  end

  unless leoni=Tenant.find_by_code('LEONI')
    leoni=Tenant.create(name: '三河莱尼线束有限公司', code: 'LEONI', short_name: '三河莱尼')
  end

  # init location
  unless (shllo=Location.find_by_nr('SHLLO'))
    shllo = Location.create(nr: 'SHLLO', name: '三河莱尼', is_base: true,
                            tenant_id: leoni.id,
                            address: '三河莱尼电器有限公司的地址',
                            receive_mode: DeliveryReceiveMode::FORKLIFT,
                            order_source_location_id:jxlo.id)
  end

  unless (hemlo=Location.find_by_nr('HEMLO'))
    hemlo = Location.create(nr: 'HEMLO', name: '常州莱尼', is_base: true,
                            tenant_id: czl.id,
                            address: '常州莱尼线束有限公司的地址')
  end

  # set as destination
  unless ps= jxlo.location_destinations.where(destination_id: shllo.id).first
    jxlo.add_destination(shllo)
  end
  unless hemlo.location_destinations.where(destination_id: jxlo.id).first
    hemlo.add_destination(jxlo)
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
    czsw=hemlo.whouses.create(nr: 'CZSend', name: '常州莱尼在途仓库')
  end
  hemlo.send_whouse=czsw
  hemlo.save

  # sh receive warehouse
  unless shrw=Whouse.find_by_nr('SHReceive')
    shrw=shllo.whouses.create(nr: 'SHReceive', name: '上海莱尼接收仓库')
  end

  shllo.receive_whouse=shrw
  shllo.save



  #佳轩扩展配置
  unless SysConfig.find_by_code('JIAXUAN_EXTRA_SOURCE')
    SysConfig.create(code: 'JIAXUAN_EXTRA_SOURCE', value: hemlo.nr, category: '佳轩扩展配置', index: 1200, name: '发运地址')
  end

  unless SysConfig.find_by_code('JIAXUAN_EXTRA_SH_CUSTOM')
    SysConfig.create(code: 'JIAXUAN_EXTRA_SH_CUSTOM', value: hem.code,category: '佳轩扩展配置', index: 1300, name: '上海客户编码')
  end

  unless SysConfig.find_by_code('JIAXUAN_EXTRA_CZ_CUSTOM')
    SysConfig.create(code: 'JIAXUAN_EXTRA_CZ_CUSTOM', value: leoni.code, category: '佳轩扩展配置', index: 1300, name: '常州客户编码')
  end


end