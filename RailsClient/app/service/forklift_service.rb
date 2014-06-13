class ForkliftService
  def self.delete id

  end

  def self.update id,args

  end

  def self.create args,current_user=nil
    
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

  def self.remove_package id,package_id
    f = Forklift.find_by_id id
    p = Package.find_by_id package_id
  end
end