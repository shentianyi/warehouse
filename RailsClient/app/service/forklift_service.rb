class ForkliftService

  #=============
  #delete @forklift
  #=============
  def self.delete forklift
    if forklift.nil?
      return false
    end

    forklift.packages.all.each do |p|
      p.remove_from_forklift
    end
    forklift.destroy
  end

  #=============
  # update @forklift,@args
  #=============
  def self.update forklift,args
    if forklift.nil?
      return  false
    end
    if args[:whouse_id]

    end
    forklift.update_attributes(args)
  end

  #=============
  # confirm_received @forklift
  # set state to RECEIVED
  #=============
  def self.confirm_received(forklift)
    if forklift.nil?
      return false
    end
    if forklift.sum_packages > forklift.accepted_packages
      forklift.set_state(ForkliftState::PART_RECEIVED)
    else
      forklift.set_state(ForkliftState::RECEIVED)
    end
  end

  #=============
  # receive @forklift
  # set state to DESTINATION
  #=============
  def self.receive(forklift)
    if forklift.nil?
      return false
    end

    forklift.set_state(ForkliftState::DESTINATION)
    forklift.packages.each do |p|
      PackageService.receive(p)
    end
    true
  end

  #=============
  # send @forklfit
  # set state to WAY
  #=============
  def self.send(forklift)
    if forklift.nil?
      return false
    end

    forklift.set_state(ForkliftState::WAY)
    forklift.packages.each do |p|
      PackageService.send(p)
    end
    true
  end

  #=============
  # check @forklift
  # set state to RECEIVED
  #=============
  def self.check forklift
    if forklift.nil?
      return false
    end
    if forklift.sum_packages == accepted_packages
      forklift.set_state(ForkliftState::RECEIVED)
    else
      return true
    end
  end

  #=============
  #avaliable_to_bind
  #=============
  def self.avaliable_to_bind
    Forklift.where('delivery_id is NULL').all.order(:created_at)
  end

  #=============
  #add_package @forklift,@package
  #add forklift to package
  #=============
  def self.add_package forklift, package
    if forklift.nil? || package.nil?
      return false
    end

    if package.forklift.nil?
      return package.add_to_forklift forklift
    else
      false
    end
  end

  #=============
  #set_state @forklift,@state
  #set forklift to a specific state
  #=============
  def self.set_state(forklift,state)
    if forklift.nil?
      return false
    end
    ActiveRecord::Base.transaction do
      if forklift.set_state(state)
        forklift.packages.each do |p|
          PackageService.set_state(p,state)
        end
      end
    end
  end

  #=============
  #remove_package
  #remove a package from a specific forklift
  #=============
  def self.remove_package package
    if package.nil?
      return false
    end
    package.remove_from_forklift
  end

  #=============
  #exits? @id
  #determine if a forklift exits
  #=============
  def self.exits? id
    Forklift.find_by_id(id)
  end
end