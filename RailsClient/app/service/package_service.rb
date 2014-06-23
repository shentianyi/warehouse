class PackageService

  #=============
  #create @args,@current_user=nil
  #=============
  def self.create args,current_user=nil
    msg = Message.new(content:[])
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
    if valid_id?(args[:id]) && valid_quantity?(args[:quantity_str])
      args[:quantity] = filt_quantity(args[:quantity_str]).to_f
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

  #=============
  #delete @package
  #=============
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

  #=============
  #update @package
  #=============
  def self.update package,args
    if package.nil?
      return false
    end

    if !PartService.validate_id(args[:part_id])
      return false
    end

    if args[:quantity_str] && PackageService.valid_quantity?(args[:quantity_str])
      args[:quantity] = PackageService.filt_quantity(args[:quantity_str])
    else
      return false
    end

    if !PackageState.can_update?(package.state)
      return false
    end

    package.update_attributes(args)
  end

  #=============
  #search @args
  #=============
  def self.search(args)
    Package.where(args).all.order(created_at: :desc)
  end

  #=============
  #exit? @id
  #detemine if a package exits?
  #=============
  def self.exits?(id)
    Package.find_by_id(id)
  end

  #=============
  #receive @package
  #receive a package,set the state from WAY to DESTINATION
  #=============
  def self.receive(package)
    if package.nil?
      return false
    end
    if !PackageState.before_state?(PackageState::DESTINATION,package.state)
      return false
    end

    package.set_state(PackageState::DESTINATION)
  end

  #=============
  #search @package
  #send a package ,and set state to WAY
  #=============
  def self.send(package)
    if package.nil?
      return false
    end
    if !PackageState.before_state?(PackageState::WAY,package.state)
      return false
    end
    package.set_state(PackageState::WAY)
  end

  #=============
  #check @package
  #check a package and set state to RECEIVED
  #=============
  def self.check package
    if package.nil?
      return false
    end

    if package.forklift.nil?
      return false
    end

    if !PackageState.before_state?(PackageState::RECEIVED,package.state)
      return false
    end

    if set_state(package,PackageState::RECEIVED)
      package.forklift.package_checked
      true
    else
      false
    end
  end

  #=============
  #check @package
  #check a package and set state to DESTINATION
  #=============
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

  #=============
  #set_state @package,@state
  #set the package to the specific state
  #=============
  def self.set_state(package,state)
    if package.nil?
      return false
    end
    package.set_state(state)
  end

  #=============
  #avaliable_to_bind @forklift_id
  #return packages avaliable for binding to a specific forklift
  #=============
  def self.avaliable_to_bind forklift_id
    if f = Forklift.find_by_id(forklift_id)
      Package.joins('INNER JOIN part_positions ON part_positions.part_id = packages.part_id').where('packages.forklift_id is NULL').select('packages.id,packages.quantity_str,packages.part_id,packages.user_id,part_positions.position_detail')
    end
  end

  #=============
  #avaliable_to_bind
  #return packages that not been added into any forklift
  #=============
  def self.avaliable_to_bind
    args = {
        forklift_id: nil
    }
    search(args)
    #Package.where('packages.forklift_id is NULL').all.order(:created_at) #.select('packages.id,packages.quantity_str,packages.part_id,packages.user_id,packages.check_in_time')
  end

  #=============
  #valid_id? @id
  #validate package id's format
  #=============
  def self.valid_id?(id)
    if id =~ $REG_PACKAGE_ID
      Package.unscoped.where(id:id).first.nil?
    else
      nil
    end
  end

  #=============
  #valid_quantity? @quantity
  #validate package quantity's format
  #=============
  def self.valid_quantity?(quantity)
    if quantity =~ $REG_PACKAGE_QUANTITY
      true
    else
      false
    end
  end

  #=============
  #filt_quantity? @quantity_str
  #filt quantity_str
  #=============
  def self.filt_quantity(quantity_str)
    if valid_quantity?(quantity_str)
      quantity_str[$FILTER_PACKAGE_QUANTITY]
    end
  end
end