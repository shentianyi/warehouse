class ForkliftService

  def self.create

  end

  def self.delete id
    f = Forklift.find_by_id id
    if f
      f.packages.all.each do |p|
        p.remove_from_forklift
      end
      f.destroy
      1
    else
      0
    end
  end

  def self.update args
    f = Forklift.find_by_id(args[:id])
    if f
      f.update_attributes(args)
      f
    else
      nil
    end
  end

  def self.avaliable_to_bind
    Forklift.where('delivery_id is NULL').all #.select('id,created_at,stocker_id,whouse_id,user_id')
  end

  def self.add_package id,package_id
    f = Forklift.find_by_id id
    p = Package.find_by_id package_id
    if f && p
      f.sum_packages = f.sum_packages + 1
      f.save
      p.add_to_forklift f.id
    end
  end

  def self.remove_package package_id
    p = Package.find_by_id package_id
    if p
      p.forklift.sum_packages = p.forklift.sum_packages - 1
      p.remove_from_forklift
    end
  end
end