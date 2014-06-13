class ForkliftService
  def delete id

  end

  def update args

  end

  def avaliable_to_bind
    Forklift.where('delivery_id is NULL')
  end

  def add_package id,package_id
    f = Forklift.find_by_id id
    p = Package.find_by_id package_id
  end

  def remove_package id,package_id

  end
end