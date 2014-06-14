class DeliveryService

  def self.delete id

  end

  def self.update args

  end

  def self.add_forklift id,forklift_id
    d = Delivery.find_by_id id
    f = Forklift.find_by_id forklift_id

    if d && f && f.delivery.nil?
      f.add_to_delivery(d.id)
    else
      false
    end
  end

  def self.remove_forklifk forklift_id
    f = Forklift.find_by_id forklift_id

    if f && f.delivery
      f.remove_from_delivery
    else
      false
    end
  end

  def self.search(args)
    Delivery.where(args).all
  end
end