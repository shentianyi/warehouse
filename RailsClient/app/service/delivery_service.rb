class DeliveryService

  def self.delete id
    d = Delivery.find_by_id(id)
    if d
      d.forklifts.each do |f|
        f.remove_from_delivery
      end
      d.destroy
      1
    else
      0
    end
  end

  def self.update args
    puts args
    d = Delivery.find_by_id(args[:id])
    if d
      d.update_attributes(args)
      d
    else
      nil
    end
  end

  def self.add_forklifts id,forklift_ids
    d = Delivery.find_by_id id
    if d
      unless forklift_ids.nil?
        forklift_ids.each do |f_id|
          f = Forklift.find_by_id(f_id)
          if f
            f.add_to_delivery(d.id)
            #f.delivery = d
            #f.save
          end
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
      result = f.remove_from_delivery == true ? 1:0
    else
      0
    end
  end

  def self.search(args)
    deliveries = Delivery.where(args).all
  end

  def exits? id
    Delivery.find_by_id(id)
  end
end