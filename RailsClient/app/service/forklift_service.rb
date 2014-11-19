class ForkliftService
  def self.create args, user
    msg = Message.new
    unless whouse=Whouse.find_by_id(args[:destinationable_id])
      msg.content = ForkliftMessage::WarehouseNotExit
      return msg
    end

    ActiveRecord::Base.transaction do
      forklift = Forklift.new(user_id: user.id, location_id: user.location_id)
      if forklift.save
        lc=forklift.logistics_containers.build(source_location_id: user.location_id, user_id: user.id)
        lc.destinationable=whouse
        lc.save

        msg.result=true
        msg.object = lc
      else
        msg.content = forklift.errors.full_messages
      end
    end
    return msg
  end

  def self.get_packages(forklift_lc)
    forklift_lc.children.joins(:package)
  end

  def self.get_part_ids(forklift_lc)
    get_packages(forklift_lc).pluck('distinct(containers.part_id)')
  end

  def self.get_packages_with_detail(forklift_lc)
    get_packages(forklift_lc).select("containers.*,location_containers.*,'#{forklift_lc.destinationable_id}' as whouse_id").collect.each { |p| p.becomes(Package) }
  end

  def self.get_bind_forklifts_by_location(location_id, user_id=nil)
    query=LogisticsContainer.joins(:forklift).where(source_location_id: location_id)
    query=query.where(user_id: user_id) if user_id
    query
  end

  def self.count_all_packages(forklift_lc)
    forklift_lc.children.count
  end

  def self.count_accepted_packages(forklift_lc)
    forklift_lc.children.where(state: MovableState::CHECKED).count
  end

  def self.search(args)
    Forklift.where(args).order(id: :desc)
  end

end
