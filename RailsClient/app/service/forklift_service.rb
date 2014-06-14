class ForkliftService
  def self.delete id
    f = Forklift.find_by_id id
    if f
      f.packages.all.each do |p|
        p.remove_from_forklift
      end
      f.destroy
    else
      false
    end
  end

  def self.update id,args
    f = Forklift.find_by_id(id)
    if f
      f.update_attributes(args)
    else
      false
    end
  end

  def self.avaliable_to_bind
    Forklift.where('delivery_id is NULL').select('id,created_at,user_id,whouse_id')
  end

  def self.add_package id,package_id
    f = Forklift.find_by_id id
    p = Package.find_by_id package_id
    if f && p
      p.add_to_forklift f.id
    end
  end

  def self.remove_package package_id
    p = Package.find_by_id package_id
    p.remove_from_forklift
  end
end