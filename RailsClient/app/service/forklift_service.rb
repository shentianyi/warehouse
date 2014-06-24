class ForkliftService

  def self.create args,current_usr=nil
    msg = Message.new
    msg.result = false
    unless whouse_exits? args[:whouse_id]
      msg.content = '部门不存在'
      return msg
    end

    if current_usr
      args[:user_id] = current_usr.id
    end

    forklift = Forklift.new(args)

    if forklift.save
      msg.result = true
      msg.object = forklift
    else
      msg.content = forklift.errors.full_messages
    end
    return msg
  end

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

    update_position = false
    if args[:whouse_id] && args[:whouse_id] != forklift.whouse_id
      update_position = true
    end


    if forklift.update_attributes(args)
      if update_position
        forklift.packages.each do |p|
          if pp = PartPosition.joins(:position).where({part_positions:{part_id:p.part_id},positions:{whouse_id: args[:whouse_id]}}).first
            puts p.package_position.to_json
            p.package_position.position_id = pp.position_id
            p.package_position.save
          end
        end
      end
      true
    else
      false
    end
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
  #add_package @forklift,@package
  #add forklift to package
  #=============
  def self.add_package forklift, package
    if forklift.nil? || package.nil?
      return false
    end

    if package.forklift_id.nil?
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

  def self.package_checked(id)
    if id
      if f = Forklift.find_by_id(id)
        f.accepted_packages = f.accepted_packages + 1
        f.save
      end
    end
  end

  def self.package_unchecked(id)
    if id
      if f = Forklift.find_by_id(id)
        f.accepted_packages = f.accepted_packages - 1
        f.save
      end
    end
  end

  def self.search(args)
    Forklift.where(args).order(created_at: :desc)
  end
end