class DeliveryService

  def self.delete id

  end

  def self.update args

  end

  def self.add_forklift id,forklift_id

  end

  def self.remove_forklifk id,forklift_id

  end

  def self.search(args)
    Delivery.where(args).all
  end
end