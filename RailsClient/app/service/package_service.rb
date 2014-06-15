class PackageService

  def self.delete id
    p = Package.find_by_id id
    if p.nil?
      false
    end
    # if this already been added into forklift
    unless p.forklift.nil?
      p.remove_from_forklift
    end
    p.destroy
  end

  # check package
  # change
  def self.check id
    p = Package.find_by_id(id)
    #
    if p
      p.state = PackageState::RECEIVED
      p.forklift.accepted_packages = p.forklift.accepted_packages + 1
      p.forklift_item.state = ForkliftItemState::RECEIVED
      p.save
    else
      false
    end
  end

  def self.reject package_id
    p = Package.find_by_id package_id
    if p
      if p.state == PackageState::RECEIVED
        p.state == PackageState::REJECTED
        p.forklift_item.state = ForkliftItemState::REJECTED
        p.forklift.accepted_packages = p.forklift.accepted_packages - 1
        p.save
      else
        false
      end
    else
      false
    end
  end

  def self.create args,current_user=nil
    package = {}
    package[:id] = args[:id]
    package[:part_id] = args[:part_id]
    package[:quantity_str] = args[:quantity]
    package[:check_in_time] =args[:check_in_time]
    #if exited
    p = Package.find_by_id(package[:id])
    if p
      p.is_delete = false
      p.update_attributes(package)
    else
      p = Package.new(package)
    end
    p.state = PackageState::ORIGINAL
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

  def self.update id,args
    p = Package.find_by_id(id)
    if p
      p.update_attributes(args)
    else
      false
    end
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