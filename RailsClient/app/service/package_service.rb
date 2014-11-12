class PackageService

  #=============
  #create @args,@current_user=nil
  #=============
  def self.create args, user
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
    p = Package.new(args)
    p.user_id=user.id
    p.location_id=user.location_id

    ActiveRecord::Base.transaction do
      if p.save
        lc=p.location_containers.build(source_location_id: p.location_id, user_id: p.user_id)
        lc.save
        msg.result = true
        msg.object = p
      else
        msg.content = p.errors.full_messages
      end
    end
    return msg
  end

#=============
#delete @package
#=============
  def self.delete id
    msg = Message.new(content: [])
    msg.result = false
    package = exits? id
    if package.nil?
      msg.content = PackageMessage::NotExit
      return msg
    end

    unless PackageState.can_delete?(package.state)
      msg.content = PackageMessage::DeleteError
      return msg
    end

    ActiveRecord::Base.transaction do
      package.remove_from_forklift
      package.destroy
      msg.result = true
      return msg
    end
  end

#=============
#update @package
#=============
  def self.update args
    msg = Message.new
    msg.result = false
    package = PackageService.exits?(args[:id])
    if package.nil?
      msg.content = PackageMessage::NotExit
      return msg
    end

    unless PackageState.can_update?(package.state)
      msg.content = PackageMessage::CannotUpdate
      return msg
    end

    unless Part.exists?(args[:part_id])
      msg.content = PackageMessage::PartNotExit
      return msg
    end


    need_set_position = false
    if args[:part_id] && package.part_id != args[:part_id]
      need_set_position = true
    end

    #if part_id changed,reset position
    ActiveRecord::Base.transaction do
      msg.result = package.update_attributes(args)
      if need_set_position
        package.set_position
      end

      if msg.result
        msg.object = package
      end
    end
    return msg
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
    if !PackageState.before_state?(PackageState::DESTINATION, package.state)
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
    unless PackageState.can_set_to?(package.state, PackageState::WAY)
      return false
    end
    package.set_state(PackageState::WAY)
  end

#=============
#check @package
#check a package and set state to RECEIVED
#=============
  def self.check id
    msg = Message.new

    package = Package.find_by_id(id)
    if package.nil?
      msg.content = PackageMessage::NotExit
      return msg
    end

    unless PackageState.can_set_to?(package.state, PackageState::RECEIVED)
      msg.content = PackageMessage::CannotCheck
      return msg
    end
    ActiveRecord::Base.transaction do
      if package.set_state(PackageState::RECEIVED)
        #ForkliftService.package_checked(package.forklift_id)
        f = package.forklift
        #f.accepted_packages = f.packages.where(state:PackageState::RECEIVED).count
        if f.accepted_packages < f.sum_packages
          f.state = ForkliftState::PART_RECEIVED
        else
          f.state = ForkliftState::RECEIVED
        end
        f.save
      end
    end
    msg.result = true
    msg.content = PackageMessage::CheckSuccess
    return msg
  end

#=============
#check @package
#check a package and set state to DESTINATION
#=============
  def self.uncheck id
    msg = Message.new

    package = Package.find_by_id id
    if package.nil?
      msg.content = PackageMessage::NotExit
      return msg
    end

    if package.state != PackageState::RECEIVED
      msg.content = PackageMessage::StateError
      return msg
    end


    unless PackageState.can_set_to?(package.state, PackageState::DESTINATION)
      msg.content = PackageMessage::CannotCancelCheck
      return msg
    end
    ActiveRecord::Base.transaction do
      if package.set_state(PackageState::DESTINATION)
        #ForkliftService.package_unchecked(package.forklift_id)
        f = package.forklift
        #f.accepted_packages = f.packages.where(state:PackageState::RECEIVED).count
        if f.accepted_packages < f.sum_packages
          f.state = ForkliftState::PART_RECEIVED
        elsif f.accepted_packages == 0
          f.state = ForkliftState::DESTINATION
        end
        f.save
      end
    end
    msg.result = true
    msg.content = PackageMessage::CancelCheckSuccess
    return msg
  end

end