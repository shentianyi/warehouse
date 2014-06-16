class PackageService

  def self.delete id
    p = Package.find_by_id id
    if p.nil?
      0
    end
    # if this already been added into forklift
    unless p.forklift.nil?
      p.remove_from_forklift
    end
    if p.destroy == true
      1
    else
      0
    end
  end

  # check package
  # change
  def self.check id
    p = Package.find_by_id(id)
    #
    if p
      p.state = PackageState::RECEIVED
      p.forklift.accepted_packages = p.forklift.accepted_packages + 1
      #p.forklift_item.state = ForkliftItemState::RECEIVED
      if p.save==true
        1
      else
        0
      end
    else
      false
    end
  end

  def self.reject package_id
    p = Package.find_by_id package_id
    if p
      if p.state == PackageState::RECEIVED
        p.state == PackageState::REJECTED
        #p.forklift_item.state = ForkliftItemState::REJECTED
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
    unless args.has_key?(:user_id)
      args[:user_id] = current_user.id
    end
    args[:location_id] = current_user.location.id

    #if exited
    p = Package.find_by_id(args[:id])
    if p
      p.is_delete = false
      p.update_attributes(args)
    else
      p = Package.new(args)
    end
    p.state = 0
    if p.save
      p
    else
      nil
    end
  end

  def self.avaliable_to_bind forklift_id
    if f = Forklift.find_by_id(forklift_id)
      Package.joins('INNER JOIN part_positions ON part_positions.part_id = packages.part_id').where('packages.forklift_id is NULL').select('packages.id,packages.quantity_str,packages.part_id,packages.user_id,part_positions.position_detail')
    end
  end

  def self.avaliable_to_bind
    Package.where('packages.forklift_id is NULL').select('packages.id,packages.quantity_str,packages.part_id,packages.user_id,packages.check_in_time')
  end

  def self.update args
    p = Package.find_by_id(args[:id])
    if p && p.update_attributes(args) == true
      1
    else
      0
    end
  end

  def self.id_avaliable? id
    unless Package.find_by_id id
      1
    else
      0
    end
  end

  def self.validate_quantity quantity
    1
  end
end