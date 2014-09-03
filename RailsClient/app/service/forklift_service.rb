class ForkliftService

  def self.create args, current_usr=nil
    msg = Message.new
    msg.result = false
    unless whouse_exits? args[:whouse_id]
      msg.content = ForkliftMessage::WarehouseNotExit
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
    ActiveRecord::Base.transaction do
      forklift.packages.all.each do |p|
        p.remove_from_forklift
      end
      forklift.destroy
    end
  end

  #=============
  # update @forklift,@args
  #=============
  def self.update forklift, args
    if forklift.nil?
      return false
    end

    update_position = false
    if args[:whouse_id] && args[:whouse_id] != forklift.whouse_id
      update_position = true
    end

    ActiveRecord::Base.transaction do
      if forklift.update_attributes(args)
        if update_position

          forklift.packages.each do |p|
            if pp = PartPosition.joins(:position).where({part_positions: {part_id: p.part_id}, positions: {whouse_id: args[:whouse_id]}}).first
              p.set_position
            end
          end
        end
        true
      else
        false
      end
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
  #verify package
  #check if parts in this warehouse
  #=============
  def self.parts_in_whouse? part_ids,whouse_id
    unless whouse = Whouse.find_by_id(whouse_id)
      return false
    end
    (part_ids - whouse.parts.ids).empty?
  end

  #=============
  # receive @forklift
  # set state to DESTINATION
  #=============
  def self.receive(forklift)
    if forklift.nil?
      return false
    end
    ActiveRecord::Base.transaction do
      forklift.set_state(ForkliftState::DESTINATION)
      forklift.packages.each do |p|
        PackageService.receive(p)
      end
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
    ActiveRecord::Base.transaction do
      forklift.packages.each do |p|
        PackageService.send(p)
      end
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
    msg = Message.new
    msg.result = false
    if package.forklift_id.nil?
      #return package.add_to_forklift forklift
      begin
        ActiveRecord::Base.transaction do
          #package.forklift_id = forklift.id
          package.update({forklift_id:forklift.id})
          package.set_position
          puts '~~~~~~~~~~~~~~~~~~~~~~'
          puts package.package_position.to_json
          true
        end
      rescue Exception=>ex
        msg.result = false
      end
    else
      false
    end
    return msg
  end

  def self.check_part_position(part,whouse_id)
    if part.positions.where(whouse_id:f.whouse_id).count > 0 || part.positions.count == 0
      true
    else
      false
    end
  end

  #=============
  #set_state @forklift,@state
  #set forklift to a specific state
  #=============
  def self.set_state(forklift, state)
    if forklift.nil?
      return false
    end
    ActiveRecord::Base.transaction do
      if forklift.set_state(state)
        forklift.packages.each do |p|
          PackageService.set_state(p, state)
        end
      end
    end
  end

  #=============
  #exits? @id
  #determine if a forklift exits
  #=============
  def self.exits? id
    Forklift.find_by_id(id)
  end

  def self.package_checked(id)
    if f = Forklift.find_by_id(id)
      #bug code
      #if f.accepted_packages < f.sum_packages
      #f.accepted_packages = f.accepted_packages + 1
      #f.save
      #end
      #f.accepted_packages = f.packages.where(state:PackageState::RECEIVED)
      #f.save
    end
  end

  def self.package_unchecked(id)
    if f = Forklift.find_by_id(id)
      #if f.accepted_packages > 0
      #f.accepted_packages = f.accepted_packages - 1
      #f.save
      #end
      #f.accepted_packages = f.packages.where(state:PackageState::RECEIVED)
      #f.save
    end
  end

  def self.search(args)
    Forklift.where(args).order(id: :desc)
  end

  def self.whouse_exits?(whouse_id)
    !Whouse.find_by_id(whouse_id).nil?
  end
end
