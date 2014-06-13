class ForkliftService
  def self.delete id

  end

  def self.update args

  end

  def self.valiable_to_bind
    Forklift.where('delivery_id is NULL')
  end

  def self.add_package id,package_id
    f = Forklift.find_by_id id
    p = Package.find_by_id package_id
    if f && p
      p.add_to_forklift f.id
    end
  end

  def self.remove_package id,package_id
    f = Forklift.find_by_id id
    p = Package.find_by_id package_id
  end
end