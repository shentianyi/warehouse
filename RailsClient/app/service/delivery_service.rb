class DeliveryService

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

  def self.update delivery,args
    if delivery.nil?
      return false
    end
    delivery.update_attributes(args)
  end

  def self.add_forklifts delivery,forklift_ids
    if delivery.nil?
      return false
    end
    ActiveRecord::Base.transaction do
      unless forklift_ids.nil?
        forklift_ids.each do |f_id|
          f = Forklift.find_by_id(f_id)
          if f
            f.add_to_delivery(delivery.id)
          end
        end
      end
    end
    true
  end

  def self.remove_forklifk forklift

    if forklift.nil?
      return false
    end

    forklift.remove_from_delivery
  end

  def self.search(args,all=false)
    if all
      Delivery.where(args)
    elsif args[:received_date].empty?
      []
    else
      received_date = Time.parse(args[:received_date])
      Delivery.where(state:args[:state],received_date:(received_date.beginning_of_day..received_date.end_of_day)).all.order(:created_at)

    end
  end

  def self.confirm_received(delivery,current_user)
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

  def self.receive(delivery)
    if delivery.nil?
      return false
    end
    ActiveRecord::Base.transaction do
      delivery.set_state(DeliveryState::DESTINATION)
      delivery.forklifts.each do |f|
        ForkliftService.receive(f)
      end
    end
    true
  end

  def self.send(delivery)
    if delivery.nil?
      return false
    end
    ActiveRecord::Base.transaction do
      delivery.source = current_user.location
      delivery.destination = Location.default_destination
      delivery.delivery_date = Time.now
      delivery.set_state(DeliveryState::WAY)
      delivery.forklifts.each do |f|
        ForkliftService.send(f)
      end
    end
    true
  end

  def self.set_state(delivery,state)
    if delivery.nil?
      return false
    end
    ActiveRecord::Base.transaction do
      if delivery.set_state(state)
        delivery.forklifts.each do |f|
          ForkliftService.set_state(f,state)
        end
      end
    end
  end

  def self.exit? id
    Delivery.find_by_id(id)
  end
end