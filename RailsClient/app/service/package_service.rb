class PackageService
  #=============
  #dispatch
  #=============
  def self.dispatch lc, destination, user
    unless (m = lc.get_movable_service.dispatch(lc, destination, user)).result
      return m
    end

    return Message.new.set_true
  end

  def self.receive lc, user
    unless (m = lc.get_movable_service.receive(lc, user)).result
      return m
    end

    return Message.new.set_true
  end

  #=============
  #search packages
  #=============
  def self.search condition
    if condition && condition['records.impl_time']
      LogisticsContainer.joins(:package).joins(:records).where(condition).distinct
    else
      LogisticsContainer.joins(:package).where(condition).distinct
    end
  end

  #=============
  #where wrapper
  #=============
  def self.where condition
    LogisticsContainer.joins(:package).where(condition)
  end

  #=============
  #create @args,@current_user=nil
  #=============
  def self.create args, user
    puts "#{args}"
    msg = Message.new
    unless Package.id_valid? args[:id]
      msg.content = PackageMessage::IdNotValid
      return msg
    end

    #part_id
    unless Part.exists?(args[:part_id])
      #err_code 10001
      msg.content = PackageMessage::PartNotExit
      return msg
    end

    #create
    ActiveRecord::Base.transaction do
      if args[:id].nil?
        msg.content = '唯一码为空'
        return msg
      end
      p = Package.new(args)
      p.user_id=user.id
      p.location_id=user.location_id

      if p.save
        lc=p.logistics_containers.build(source_location_id: p.location_id, user_id: p.user_id)
        lc.save
        lc.package=p
        msg.result = true
        msg.object = lc
      else
        msg.content = p.errors.full_messages
      end
    end
    return msg
  end


  #=============
  #update @package
  #=============
  def self.update args
    msg = Message.new
    unless lc= LogisticsContainer.exists?(args[:id])
      msg.content = PackageMessage::NotExit
      return msg
    end
    package=lc.package

    unless lc.can_update?
      msg.content = PackageMessage::CannotUpdate
      return msg
    end

    unless Part.exists?(args[:part_id])
      msg.content = PackageMessage::PartNotExit
      return msg
    end

    #
    args[:id] = lc.container_id

    if msg.result=package.update_attributes(args)
      lc.package=package
      msg.object = lc
    end
    return msg
  end

  def self.get_bind_packages_by_location(location_id, user_id=nil)
    query=Package.joins(:logistics_containers).where(location_containers: {source_location_id: location_id, ancestry: nil})
    query=query.where(location_containers: {user_id: user_id}) if user_id
    query.select('containers.*,location_containers.*')
  end


  #create package
  def self.generate_package(row, user)
    #create container
    package = Package.create({
                                 id: row[:packageId],
                                 part_id: row[:partNr],
                                 user_id: user.id,
                                 quantity: row[:qty],
                                 state: PackageState::RECEIVED,
                                 supplier: row[:supplier],
                                 batch_nr: row[:batch_nr]
                             })
    #create lc
    plc = package.logistics_containers.build({
                                                 user_id: user.id,
                                                 state: MovableState::CHECKED
                                             })
    # plc.destinationable = destination
    plc.save

    Record.create({recordable: plc, impl_id: user.id, impl_user_type: ImplUserType::RECEIVER, impl_action: 'receive', impl_time: Time.now})
    # forklifts[row[:forklift_id]].add(plc)
  end

end