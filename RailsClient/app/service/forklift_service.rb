class ForkliftService
  def self.delete forklift
    if forklift.nil?
      return false
    end

    forklift.packages.all.each do |p|
      p.remove_from_forklift
    end
    forklift.destroy
  end

  def self.check forklift
    if forklift.nil?
      return false
    end
    if forklift.sum_packages == accepted_packages
      forklift.set_state(ForkliftState::RECEIVED)
    else
      return true
    end

=begin
    if forklift.set_state(ForkliftState::RECEIVED)
      forklift.packages.each do |p|
        p.set_state(PackageState::RECEIVED)
      end
    else
      return false
    end
=end
  end

  def self.update forklift,args
    if forklift.nil?
      return  false
    end
    forklift.update_attributes(args)
  end

  def self.avaliable_to_bind
    Forklift.where('delivery_id is NULL').all.order(:created_at)
  end

  def self.add_package forklift, package
    if forklift.nil? || package.nil?
      return false
    end

    if package.forklift.nil?
      return package.add_to_forklift forklift
    end
    true
  end

  def self.remove_package package
    if package.nil?
      return false
    end
    package.remove_from_forklift
  end

  def self.exits? id
    Forklift.find_by_id(id)
  end
end