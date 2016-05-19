ActiveRecord::Base.transaction do

  unless t=Tenant.find_by_code('SHWX')
    t=Tenant.create(name: '上海稳信有限公司', code: 'SHWX', short_name: '上海稳信简称', type: TenantType::SELF)
  end

  # init location and admin
  unless (wxlo=Location.find_by_nr('SHWXLO'))
    wxlo = Location.create(nr: 'SHWXLO', name: '上海稳信', is_base: true,
                           tenant_id: t.id,
                           address: '上海稳信有限公司的地址')
  end

  unless user=User.find_by_nr('admin')
    user = User.create({name: 'Admin', location_id: wxlo.id,
                        password: '123456@',
                        password_confirmation: '123456@', role_id: 100, is_sys: true, nr: 'admin'})
  end

  # init warehouse
  unless rw=Whouse.find_by_nr('WXReceive')
    rw=Whouse.create(nr: 'WXReceive', name: '缓冲库')
  end
  unless mw=Whouse.find_by_nr('Material')
    mw=Whouse.create(nr: 'Material', name: '原材料库')
  end
  unless sfw=Whouse.find_by_nr('SemiFinished')
    sfw=Whouse.create(nr: 'SemiFinished', name: '半成品库')
  end
  unless fw=Whouse.find_by_nr('Finished')
    fw=Whouse.create(nr: 'Finished', name: '成品库')
  end
  unless sw=Whouse.find_by_nr('Scrap')
    sw=Whouse.create(nr: 'Scrap', name: '报废库')
  end
  unless rew=Whouse.find_by_nr('Rework')
    rew=Whouse.create(nr: 'Rework', name: '不良品库')
  end

  wxlo.whouses << [rw, mw, sfw, fw, sw, rew]
  wxlo.receive_whouse=rw
  wxlo.save
end