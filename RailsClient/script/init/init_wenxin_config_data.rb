ActiveRecord::Base.transaction do

  # init location and admin
  unless (wxlo=Location.find_by_id('SHWXLO'))
    wxlo = Location.create(id: 'SHWXLO', name: '上海稳信', is_base: true,
                           address: '上海稳信有限公司的地址')
  end

  unless user=User.find_by_id('admin')
    user = User.create({name: 'Admin', location_id: wxlo.id,
                        password: '123456@',
                        password_confirmation: '123456@', role_id: 100, is_sys: true, id: 'admin'})
  end

  # init warehouse
  unless rw=Whouse.find_by_id('WXReceive')
    rw=Whouse.create(id: 'WXReceive', name: '缓冲库')
  end
  unless mw=Whouse.find_by_id('Material')
    mw=Whouse.create(id: 'WXSend', name: '原材料库')
  end
  unless sfw=Whouse.find_by_id('SemiFinished')
    sfw=Whouse.create(id: 'SemiFinished', name: '半成品库')
  end
  unless fw=Whouse.find_by_id('Finished')
    fw=Whouse.create(id: 'Finished', name: '成品库')
  end
  unless sw=Whouse.find_by_id('Scrap')
    sw=Whouse.create(id: 'Scrap', name: '报废库')
  end
  unless rew=Whouse.find_by_id('Rework')
    rew=Whouse.create(id: 'Rework', name: '不良品库')
  end

  # [rw, mw, sfw, fw, sw, rew].each do |w|
    wxlo.whouses << [rw, mw, sfw, fw, sw, rew]
  # end

end