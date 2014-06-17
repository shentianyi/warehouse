class PackageService

  def self.delete package
    if package.nil?
      return
    end

    if PackageState.can_delete?(package.state)
      package.remove_from_forklift
      package.destroy
    end
  end

  # check package
  # change,received
  def self.check package
    if package.nil?
      return
    end
    package.state = PackageState::RECEIVED
    package.forklift.accepted_packages = p.forklift.accepted_packages + 1
    package.save
  end

  def self.reject package
    if package.nil?
      return
    end
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
    if !part_exits?(args[:part_id])
      msg.content = '零件号不存在'
      return msg
    end
    #if exited
    if package_id_avaliable?(args[:id])
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
    Package.where('packages.forklift_id is NULL').all #.select('packages.id,packages.quantity_str,packages.part_id,packages.user_id,packages.check_in_time')
  end

  def self.update package,args
    if package.nil?
      return false
    end

    if !PackageState.can_update?(package.state)
      return false
    end

    package.update_attributes(args)
  end

  def self.package_id_avaliable?(id)
    Package.unscoped.where(id:id,is_delete:[0,1]).first.nil?
  end

  def self.package_exits?(id)
    p = Package.find_by_id(id)
  end

  def self.part_exits?(id)
    !Part.find_by_id(id).nil?
  end
end