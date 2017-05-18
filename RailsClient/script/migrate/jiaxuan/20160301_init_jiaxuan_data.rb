ActiveRecord::Base.transaction do

  unless t=Tenant.find_by_code('CQJX')
    t=Tenant.create(name: '重庆佳轩物流有限公司', code: 'CQJX', short_name: '上海佳轩简称', type: TenantType::SELF)
  end
  
  # init location and admin
  unless (jxlo=Location.find_by_nr('SHCQJXLO'))
    jxlo = Location.create(nr: 'SHCQJXLO', name: '重庆佳轩物流', is_base: true,
                           tenant_id: t.id,
                           address: '重庆市北碚区同源路53号',
                           receive_mode: DeliveryReceiveMode::PACKAGE)
  end

  unless user=User.find_by_nr('admin')
    user = User.create({name: 'Admin', location_id: jxlo.id,
                        password: '123456@',
                        password_confirmation: '123456@', role_id: 100, is_sys: true, nr: 'admin'})
  end

  # init client
  unless cqle=Tenant.find_by_code('CQLE')
    cqle=Tenant.create(name: '重庆李尔', code: 'CQLE', short_name: '重庆李尔')
  end

  unless czl=Tenant.find_by_code('CZL')
    czl=Tenant.create(name: '常州莱尼线束有限公司', code: 'CZL', short_name: '常州莱尼')
  end

  # init location
  unless (cqlelo=Location.find_by_nr('CQLELO'))
    cqlelo = Location.create(nr: 'CQLELO', name: '重庆李尔', is_base: true,
                            tenant_id: cqle.id,
                            address: '重庆李尔有限公司的地址',
                            receive_mode: DeliveryReceiveMode::FORKLIFT,
                            order_source_location_id:jxlo.id)
  end

  unless (czllo=Location.find_by_nr('CZLLO'))
    czllo = Location.create(nr: 'CZLLO', name: '常州莱尼', is_base: true,
                            tenant_id: czl.id,
                            address: '常州莱尼线束有限公司的地址')
  end

  # set as destination
  unless ps= jxlo.location_destinations.where(destination_id: cqlelo.id).first
    jxlo.add_destination(cqlelo)
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
  unless shrw=Whouse.find_by_nr('CQLEReceive')
    shrw=cqlelo.whouses.create(nr: 'CQLEReceive', name: '重庆李耳接收仓库')
  end

  cqlelo.receive_whouse=shrw
  cqlelo.save



  #佳轩扩展配置
  unless SysConfig.find_by_code('JIAXUAN_EXTRA_SOURCE')
    SysConfig.create(code: 'JIAXUAN_EXTRA_SOURCE', value: czllo.nr, category: '佳轩扩展配置', index: 1200, name: '发运地址')
  end

  unless SysConfig.find_by_code('JIAXUAN_EXTRA_SH_CUSTOM')
    SysConfig.create(code: 'JIAXUAN_EXTRA_SH_CUSTOM', value: cqle.code,category: '佳轩扩展配置', index: 1300, name: '重庆客户编码')
  end

  unless SysConfig.find_by_code('JIAXUAN_EXTRA_CZ_CUSTOM')
    SysConfig.create(code: 'JIAXUAN_EXTRA_CZ_CUSTOM', value: czl.code, category: '佳轩扩展配置', index: 1300, name: '常州客户编码')
  end


end