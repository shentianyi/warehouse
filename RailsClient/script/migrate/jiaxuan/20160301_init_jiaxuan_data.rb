ActiveRecord::Base.transaction do

  t=Tenant.create(name: '上海佳轩物流有限公司', code: 'SHJX', short_name: '简称', type: TenantType::SELF)

  # init location and admin
  unless (jxlo=Location.find_by_id('SHJXLO'))
    jxlo = Location.create(nr: 'SHJXLO', name: ' 上海佳轩物流', is_base: true,
                        tenant_id: t.id,
                        address: '上海佳轩物流有限公司的地址')
  end

  unless user=User.find_by_id('admin')
    user = User.create({name: 'Admin', location_id: jxlo.id,
                        password: '123456@',
                        password_confirmation: '123456@', role_id: 100, is_sys: true, nr: 'admin'})
  end

  # init client
  unless shl=Tenant.find_by_code('SHL')
    shl=Tenant.create(name: '上海莱尼电器有限公司', code: 'SHL', short_name: '上海莱尼')
  end

  unless czl=Tenant.find_by_code('czl')
    czl=Tenant.create(name: '常州莱尼线束有限公司', code: 'CZL', short_name: '常州莱尼')
  end

  # init location
  unless (shllo=Location.find_by_id('SHLLO'))
    shllo = Location.create(nr: 'SHLLO', name: ' 上海莱尼', is_base: true,
                        tenant_id: shl.id,
                        address: '上海莱尼电器有限公司的地址')
  end

  unless (czllo=Location.find_by_id('CZLLO'))
    czllo = Location.create(nr: 'CZLLO', name: '常州莱尼', is_base: true,
                           tenant_id: czl.id,
                           address: '常州莱尼线束有限公司的地址')
  end

  # set as destination
  unless jxlo.destinations.where(id: shllo.id).first
    jxlo.add_destination(shllo)
  end
  unless czllo.destinations.where(id: jxlo.id).first
    czllo.add_destination(jxlo)
  end



end