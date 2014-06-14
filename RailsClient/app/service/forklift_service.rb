class ForkliftService
  def self.delete id

  end

  def self.update id,args

  end

  def self.create args,current_user=nil
    forklift = {}
    forklift[:whouse_id] = args[:whouse_id]
    forklift[:stocker_id] = args[:user_id]
    f = Forklift.new(forklift)
    if current_user
      f.user = current_user.id
    end
    if result = f.save
      {result:result,content:{id:f.id,whouse_id:f.whouse_id,created_at:f.created_at,user_id:f.stocker_id}}
    else
      {result:result,content:f.errors}
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

  def self.remove_package id,package_id
    f = Forklift.find_by_id id
    p = Package.find_by_id package_id
  end
end