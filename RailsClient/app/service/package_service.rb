class PackageService

  def self.delete package
    if package.nil?
      return false
    end

    ActiveRecord::Base.transaction do
      if PackageState.can_delete?(package.state)
        package.remove_from_forklift
        package.destroy
      else
        return false
      end
    end

  end

  def self.receive(package)
    if package.nil?
      return false
    end
    package.set_state(PackageState::DESTINATION)
  end

  def self.send(package)
    if package.nil?
      return false
    end
    package.set_state(PackageState::WAY)
  end

  # check package
  # change,received
  def self.check package
    if package.nil?
      return false
    end

    if package.forklift.nil?
      return false
    end

    if set_state(package,PackageState::RECEIVED)
      package.forklift.package_checked
      true
    else
      false
    end
  end

  def self.uncheck package
    if package.nil?
      return false
    end

    if package.forklift.nil?
      return false
    end

    if set_state(package,PackageState::DESTINATION)
      package.forklift.package_unchecked
      true
    else
      false
    end
  end

  def self.reject package
    if package.nil?
      return false
    end
    true
  end

  def self.set_state(package,state)
    if package.nil?
      return false
    end
    package.set_state(state)
  end

  def self.create args,current_user=nil
    msg = Message.new
    msg.result = false

    #current_user
    unless args.has_key?(:user_id)
      args[:user_id] = current_user.id
    end
    args[:location_id] = current_user.location.id if current_user.location
    #
    if !PartService.validate_id(args[:part_id])
      msg.content = '零件号不存在'
      return msg
    end
    #if exited
    if package_id_avaliable?(args[:id]) && valid_package_quantity?(args[:quantity_str])
      args[:quantity] = quantity_filter(args[:quantity_str]).to_f
      p = Package.new(args)
      if p.save
        msg.result = true
        msg.object = p
      else
        msg.content << p.errors.full_messages
      end
    else
      msg.content << '唯一号重复,请使用新的唯一号'
    end
    msg
  end

  def self.avaliable_to_bind forklift_id
    if f = Forklift.find_by_id(forklift_id)
      Package.joins('INNER JOIN part_positions ON part_positions.part_id = packages.part_id').where('packages.forklift_id is NULL').select('packages.id,packages.quantity_str,packages.part_id,packages.user_id,part_positions.position_detail')
    end
  end

  def self.avaliable_to_bind
    Package.where('packages.forklift_id is NULL').all.order(:created_at) #.select('packages.id,packages.quantity_str,packages.part_id,packages.user_id,packages.check_in_time')
  end

  def self.update package,args
    if package.nil?
      return false
    end

    if !PartService.validate_id(args[:part_id])
      return false
    end

    if args[:quantity_str] && PackageService.valid_package_quantity?(args[:quantity_str])
      args[:quantity] = PackageService.quantity_filter(args[:quantity_filter])
    else
      return false
    end

    if !PackageState.can_update?(package.state)
      return false
    end

    package.update_attributes(args)
  end

  def self.package_id_avaliable?(id)
    if id =~ $REG_PACKAGE_ID
      Package.unscoped.where(id:id,is_delete:[0,1]).first.nil?
    else
      nil
    end
  end

  def self.exits?(id)
    Package.find_by_id(id)
  end

  def self.valid_package_quantity?(id)
    if id =~ $REG_PACKAGE_QUANTITY
      true
    else
      false
    end
  end

  def self.quantity_filter(id)
    puts $REG_PACKAGE_QUANTITY.to_s
    if valid_package_quantity?(id)
      id[$FILTER_PACKAGE_QUANTITY]
    end
  end
end