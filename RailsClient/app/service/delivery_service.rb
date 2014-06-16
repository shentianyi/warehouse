class DeliveryService

  def self.delete id
    d = Delivery.find_by_id(id)
    if d
      d.forklifts.each do |f|
        f.remove_from_delivery
        d.destroy
      end
    else
      false
    end
  end

  def self.update args

  end

  def self.add_forklifts id,forklift_ids
    d = Delivery.find_by_id id

    if d
      forklift_ids.each do |f_id|
        f = Forklift.find_by_id(f_id)
        if f
          f.add_to_delivery(d.id)
        end
      end
      1
    else
      0
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