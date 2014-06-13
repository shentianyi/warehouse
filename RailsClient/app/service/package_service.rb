class PackageService

  def self.delete id
    p = Package.find_by_id id
    if p.nil?
      false
    end
    p.destroy
  end

  def self.create args,current_user=nil
    package = {}
    package[:id] = args[:id]
    package[:part_id] = args[:part_id]
    package[:quantity_str] = args[:quantity]
    package[:check_in_time] =args[:check_in_time]
    p = Package.new(package)
    if current_user
      p.user = current_user
      p.location = current_user.location
    end
    p.save
  end

  def self.avaliable_to_bind forklift_id
    if f = Forklift.find_by_id(forklift_id)
      Package.joins('INNER JOIN part_positions ON part_positions.part_id = packages.part_id').where('packages.id not in (select package_id from forklift_items) and part_positions.whouse_id = ?',f.whouse_id).select('packages.id,packages.quantity_str,packages.part_id,packages.user_id,part_positions.position_detail')
    end
  end

  def self.avaliable_to_bind
    Package.where('packages.id not in (select package_id from forklift_items)').select('packages.id,packages.quantity_str,packages.part_id,packages.user_id,packages.check_in_time')
  end

  def self.update args

  end

  def self.id_avaliable? id
    unless Package.find_by_id id
      true
    else
      false
    end
  end

  def self.validate_quantity quantity
    true
  end
end