class PackageService

  #=============
  #create @args,@current_user=nil
  #=============
  def self.create args, current_user=nil
<<<<<<< HEAD
    msg = Message.new
    msg.content=[]
=======
    msg = Message.new(content: [])
    msg.result = false

    unless valid_id? args[:id]
      msg.content = PackageMessage::IdNotValid
      return msg
    end

>>>>>>> 273a9c3ace444055ccbf56aad03df93cfc321fc3
    #current_user
    unless args.has_key?(:user_id)
      args[:user_id] = current_user.id
      args[:location_id] = current_user.location_id if current_user.location_id
    end

    #part_id
    unless part_exit?(args[:part_id])
      #err_code 10001
      msg.content = PackageMessage::PartNotExit
      return msg
    end

    #if exited
    unless quantity_string_valid?(args[:quantity_str])
      msg.content = PackageMessage::QuantityStringError
      return msg
    end

    #current_user
    unless args.has_key?(:user_id)
      args[:user_id] = current_user.id
      args[:location_id] = current_user.location_id if current_user.location_id
    end

    #create
    args[:quantity] = filt_quantity(args[:quantity_str]).to_f
    p = Package.new(args)
    if p.save
      msg.result = true
      msg.object = p
    else
      msg.content << p.errors.full_messages
    end
    return msg
  end

<<<<<<< HEAD
  #=============
  #update @package
  #=============
  def self.update package, args
    if package.nil?
      return false
    end

    if !PartService.validate_id(args[:part_id])
      return false
    end
=======
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
>>>>>>> 273a9c3ace444055ccbf56aad03df93cfc321fc3

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

  unless part_exit?(args[:part_id])
    msg.content = PackageMessage::PartNotExit
    return msg
  end

<<<<<<< HEAD
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
=======
  if args[:quantity_str] && quantity_string_valid?(args[:quantity_str])
    args[:quantity] = PackageService.filt_quantity(args[:quantity_str])
  else
    msg.content = PackageMessage::QuantityStringError
    return msg
  end
>>>>>>> 273a9c3ace444055ccbf56aad03df93cfc321fc3

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
<<<<<<< HEAD
    if !PackageState.before_state?(PackageState::WAY, package.state)
      return false
=======
    if msg.result
      msg.object = package
>>>>>>> 273a9c3ace444055ccbf56aad03df93cfc321fc3
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

<<<<<<< HEAD
    if !PackageState.before_state?(PackageState::RECEIVED, package.state)
      return false
    end

    if set_state(package, PackageState::RECEIVED)
      package.forklift.package_checked
      true
    else
      false
    end
=======
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
>>>>>>> 273a9c3ace444055ccbf56aad03df93cfc321fc3
  end
  package.set_state(PackageState::WAY)
end

#=============
#check @package
#check a package and set state to RECEIVED
#=============
def self.check id
  msg = Message.new
  msg.result = false

  package = exits? id
  if package.nil?
    msg.content = PackageMessage::NotExit
    return msg
  end

<<<<<<< HEAD
    if set_state(package, PackageState::DESTINATION)
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
  def self.set_state(package, state)
    if package.nil?
      return false
    end
    package.set_state(state)
=======
  unless PackageState.can_set_to?(package.state, PackageState::RECEIVED)
    msg.content = PackageMessage::CannotCheck
    return msg
  end

  if package.set_state(PackageState::RECEIVED)
    ForkliftService.package_checked(package.forklift_id)
>>>>>>> 273a9c3ace444055ccbf56aad03df93cfc321fc3
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
  msg.result = false

  package = exits? id
  if package.nil?
    msg.content = PackageMessage::NotExit
    return msg
  end

  if package.state != PackageState::RECEIVED
    msg.content = PackageMessage::StateError
    return msg
  end

<<<<<<< HEAD
  #=============
  #valid_id? @id
  #validate package id's format
  #=============
  def self.valid_id?(id)
    if id =~ $REG_PACKAGE_ID
      Package.unscoped.where(id: id, is_delete: [0, 1]).first.nil?
    else
      nil
    end
=======
  unless PackageState.can_set_to?(package.state, PackageState::DESTINATION)
    msg.content = PackageMessage::CannotCancelCheck
    return msg
>>>>>>> 273a9c3ace444055ccbf56aad03df93cfc321fc3
  end

  if package.set_state(PackageState::DESTINATION)
    ForkliftService.package_unchecked(package.forklift_id)
  end
  msg.result = true
  msg.content = PackageMessage::CancelCheckSuccess
  return msg
end

#=============
#valid_id? @id
#validate package id's format
#=============
def self.valid_id?(id)
  if id && id =~ $REG_PACKAGE_ID
    Package.unscoped.where(id: id).first.nil?
  else
    false
  end
end

#=============
#filt_quantity? @quantity_str
#filt quantity_str
#=============
def self.filt_quantity(quantity_str)
  quantity_str[$FILTER_PACKAGE_QUANTITY]
end

def self.part_exit?(part_id)
  !Part.find_by_id(part_id).nil?
end

def self.quantity_string_valid?(quantity_string)
  if quantity_string =~ $REG_PACKAGE_QUANTITY
    true
  else
    false
  end
end

end