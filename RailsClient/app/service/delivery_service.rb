class DeliveryService

  def delete id

  end

  def update args

  end

  def add_forklift id, forklift_id

  end

  def remove_forklifk id, forklift_id

  end

  def self.search(args)
    Delivery.where(args).all
  end
end