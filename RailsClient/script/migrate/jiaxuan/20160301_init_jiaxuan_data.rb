ActiveRecord::Base.transaction do

  unless t=Tenant.find_by_code('XSJX')
    t=Tenant.create(name: '萧山佳轩物流有限公司', code: 'XSJX', short_name: '萧山佳轩', type: TenantType::SELF)
  end

  
  # init location and admin
  unless (jxlo=Location.find_by_nr('XSJXLO'))
    jxlo = Location.create(nr: 'XSJXLO', name: '萧山佳轩', is_base: true,
                           tenant_id: t.id,
                           address: '萧山佳轩物流有限公司的地址',
                           receive_mode: DeliveryReceiveMode::PACKAGE)
  end

  unless user=User.find_by_nr('admin')
    user = User.create({name: 'Admin', location_id: jxlo.id,
                        password: '123456@',
                        password_confirmation: '123456@', role_id: 100, is_sys: true, nr: 'admin'})
  end

  # init client
  unless shl=Tenant.find_by_code('GQ')
    shl=Tenant.create(name: '广汽工厂', code: 'GQ', short_name: '广汽工厂')
  end

  unless czl=Tenant.find_by_code('SPL')
    czl=Tenant.create(name: '广汽供应商', code: 'SPL', short_name: '广汽供应商')
  end

  # init location
  unless (shllo=Location.find_by_nr('GQLO'))
    shllo = Location.create(nr: 'GQLO', name: '广汽工厂', is_base: true,
                            tenant_id: shl.id,
                            address: '广汽工厂的地址',
                            receive_mode: DeliveryReceiveMode::FORKLIFT,
                            order_source_location_id:jxlo.id)
  end

  unless (czllo=Location.find_by_nr('SPLLO'))
    czllo = Location.create(nr: 'SPLLO', name: '广汽供应商', is_base: true,
                            tenant_id: czl.id,
                            address: '广汽供应商的地址')
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
    rw=jxlo.whouses.create(nr: 'JXReceive', name: '萧山佳轩接收仓库')
  end
  # send warehouse
  unless sw=Whouse.find_by_nr('JXSend')
    sw=jxlo.whouses.create(nr: 'JXSend', name: '萧山佳轩在途仓库')
  end

  jxlo.receive_whouse=rw
  jxlo.send_whouse=sw
  jxlo.save

  # cz send warehouse
  unless czsw=Whouse.find_by_nr('SPLSend')
    czsw=czllo.whouses.create(nr: 'SPLSend', name: '广汽供应商在途仓库')
  end
  czllo.send_whouse=czsw
  czllo.save

  # sh receive warehouse
  unless shrw=Whouse.find_by_nr('GQReceive')
    shrw=shllo.whouses.create(nr: 'GQReceive', name: '广汽工厂接收仓库')
  end

  shllo.receive_whouse=shrw
  shllo.save



  #佳轩扩展配置
  unless SysConfig.find_by_code('JIAXUAN_EXTRA_SOURCE')
    SysConfig.create(code: 'JIAXUAN_EXTRA_SOURCE', value: czllo.nr, category: '萧山佳轩扩展配置', index: 1200, name: '发运地址')
  end

  unless SysConfig.find_by_code('JIAXUAN_EXTRA_GQ_CUSTOM')
    SysConfig.create(code: 'JIAXUAN_EXTRA_GQ_CUSTOM', value: shl.code,category: '萧山佳轩扩展配置', index: 1300, name: '广汽客户编码')
  end

  unless SysConfig.find_by_code('JIAXUAN_EXTRA_SPL_CUSTOM')
    SysConfig.create(code: 'JIAXUAN_EXTRA_SPL_CUSTOM', value: czl.code, category: '萧山佳轩扩展配置', index: 1300, name: '广汽供应商客户编码')
  end


end