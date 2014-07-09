class DeliveryService

  #=============
  #delete @delivery
  #delete a delivery
  #=============
  def self.delete delivery
    if delivery
      delivery.forklifts.each do |f|
        f.remove_from_delivery
      end
      delivery.destroy
    else
      false
    end
  end

  #=============
  #update @args
  #update a delivery
  #=============
  def self.update delivery, args
    if delivery.nil?
      return false
    end
    delivery.update_attributes(args)
  end

  def self.add_forklifts delivery, forklift_ids
    if delivery.nil?
      return false
    end
    ActiveRecord::Base.transaction do
      unless forklift_ids.nil?
        forklift_ids.each do |f_id|
          f = Forklift.find_by_id(f_id)
          if f && f.packages.count > 0
            f.add_to_delivery(delivery.id)
          end
        end
      end
    end
    true
  end

  #=============
  #remove_forklifk @forklift
  #remove a forklift from delivery
  #=============
  def self.remove_forklifk forklift

    if forklift.nil?
      return false
    end

    forklift.remove_from_delivery
  end

  #=============
  #serarch args,all=false
  #search delivery if all is true,return all packages' detail information
  #=============
  def self.search(args, all=false)
    if all
      Delivery.where(args).order(created_at: :desc)
    elsif args[:received_date].empty?
      []
    else
      received_date = Time.parse(args[:received_date])
      Delivery.where(state: args[:state], received_date: (received_date.beginning_of_day..received_date.end_of_day)).all.order(:created_at).order(created_at: :desc)
    end
  end

  #=============
  #confirm_received @delivery,@current_user
  #set the delivery state to RECEIVED
  #=============
  def self.confirm_received(delivery, current_user)
    if delivery.nil?
      return false
    end
    ActiveRecord::Base.transaction do
      if delivery.set_state(DeliveryState::RECEIVED)
        delivery.forklifts.each do |f|
          ForkliftService.confirm_received(f)
        end
        delivery.receiver = current_user
        delivery.received_date = Time.now
        delivery.save
      else
        false
      end
    end
  end

  #=============
  #receive @delivery
  #set state to DESTINATION
  #=============
  def self.receive(delivery)
    if delivery.nil?
      return false
    end
    if !DeliveryState.before_state?(DeliveryState::DESTINATION,delivery.state)
      return false
    end
    ActiveRecord::Base.transaction do
      if !delivery.set_state(DeliveryState::DESTINATION)
        return false
      end
      delivery.forklifts.each do |f|
        ForkliftService.receive(f)
      end
    end
    true
  end

  #=============
  #semd @delivery
  #set state to WAY
  #=============
  def self.send(delivery, current_user)
    if delivery.nil?
      return false
    end

    if delivery.forklifts.count == 0
      return false
    end

    ActiveRecord::Base.transaction do
      delivery.source = current_user.location
      delivery.destination = current_user.location.destination
      delivery.delivery_date = Time.now
      delivery.set_state(DeliveryState::WAY)
      delivery.forklifts.each do |f|
        ForkliftService.send(f)
      end
    end
    true
  end

  #=============
  #set_state @delivery,@state
  #set delivery to a specific state
  #=============
  def self.set_state(delivery, state)
    if delivery.nil?
      return false
    end
    ActiveRecord::Base.transaction do
      if delivery.set_state(state)
        delivery.forklifts.each do |f|
          ForkliftService.set_state(f, state)
        end
      end
    end
  end

  #=============
  #exit? @id
  #=============
  def self.exit? id
    Delivery.find_by_id(id)
  end

  #=============
  #import_by_file
  #=============
  def self.import_by_file path
    msg=Message.new
    ActiveRecord::Base.transaction do
      Sync::Config.skip_muti_callbacks([Delivery, Forklift, Package, PackagePosition, StateLog])
      data=JSON.parse(IO.read(path))
      msg.result =true unless Delivery.find_by_id(data['delivery']['id'])
      Delivery.create(data['delivery'])
      Forklift.create(data['forklifts'])
      Package.create(data['packages'])
      PackagePosition.create(data['package_positions'])
      StateLog.create(data['state_logs'])
    end
    return msg
  end
end