Container.transaction do
  # create package and add to forklift
  user=User.find('00507851')
  forklift_arg={
      destinationable_id: '3EX'
  }
  forklift=ForkliftService.create(forklift_arg, user).object
  forklift.update_attributes(remark: '系统补缺')


  package_args=[]
  package_arg1= {
      id: 'WI301501168942',
      part_id: '418487500',
      part_id_display: 'P418487500',
      quantity: '3000',
      quantity_display: 'Q3000',
      custom_fifo_time: '26/06/14',
      fifo_time_display: 'W  26/06/14'
  }
  package_args<<package_arg1

  package_args.each do |package_arg|
    package=PackageService.create(package_arg, user).object
    forklift.add(package)
    package.update({destinationable: forklift.destinationable})
  end

  # update package info
  if container=Container.find_by_id('WI301501168652')
    container.update_attributes(part_id: '420002438',
                                part_id_display: 'P420002438',
                                quantity: '100',
                                quantity_display: 'Q100.000')
    NStorage.where(packageId: 'WI301501168652').destroy_all
    Movement.where(packageId: 'WI301501168652').destroy_all
    if lc=container.logistics_containers.first
      lc.enter_stock
    end
  end


  if container=Container.find_by_id('WI301501165817')
    container.update_attributes(part_id: 'P00124556',
                                part_id_display: 'PP00124556',
                                quantity: '200',
                                quantity_display: 'Q200.000')
    NStorage.where(packageId: 'WI301501165817').destroy_all
    Movement.where(packageId: 'WI301501165817').destroy_all
    if lc=container.logistics_containers.first
      lc.enter_stock
    end
  end

  if container=Container.find_by_id('WI301501168332')
    container.update_attributes(part_id: '76755022W116',
                                part_id_display: 'P76755022W116',
                                quantity: '1000',
                                quantity_display: 'Q1000.000')
    NStorage.where(packageId: 'WI301501168332').destroy_all
    Movement.where(packageId: 'WI301501168332').destroy_all
    if lc=container.logistics_containers.first
      lc.enter_stock
    end
  end


  if container=Container.find_by_id('WI301501168410')
    container.update_attributes(part_id: '76755041W333',
                                part_id_display: 'P76755041W333',
                                quantity: '1000',
                                quantity_display: 'Q1000.000')
    NStorage.where(packageId: 'WI301501168410').destroy_all
    Movement.where(packageId: 'WI301501168410').destroy_all
    if lc=container.logistics_containers.first
      lc.enter_stock
    end
  end

  # update qty
  if container=Container.find_by_id('WI301501168541')
    container.update_attributes(quantity: '500',
                                quantity_display: 'Q500.000')
    NStorage.where(packageId: 'WI301501168541').update_all(qty: 500)
    Movement.where(packageId: 'WI301501168541').update_all(qty: 500)
  end

  # destroy pacakge
  if container=Container.find_by_id('WI301501165739')
    container.destroy
    NStorage.where(packageId: 'WI301501165739').destroy_all
    Movement.where(packageId: 'WI301501165739').destroy_all
  end
end