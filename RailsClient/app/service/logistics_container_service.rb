class LogisticsContainerService
  #目前这个Service有问题，应该通过调用各自的dispath来进行分发，
  #以实现各自的逻辑，但是目前没有时间了。

  def self.destroy_by_id(id)
    msg=Message.new
    if lc=LogisticsContainer.exists?(id)
      if lc.can_update?
        ActiveRecord::Base.transaction do
          lc.children.each do |c|
            c.remove
          end
          lc.parent=nil
          lc.destroy
        end
        msg.result = true
      else
        msg.content =BaseMessage::STATE_CANNOT_DESTROY
      end
    else
      msg.content =BaseMessage::NOT_EXISTS
    end
    msg
  end

  def self.search(condition)
    LogisticsContainer.where(condition)
  end

  def self.dispatch(lc, destination, user)
    msg = Message.new
    return msg.set_true()
  end

  def self.receive(lc, user)
    msg = Message.new
    return msg.set_true()
  end

  def self.check(lc, user)
    msg = Message.new
    return msg.set_true()
  end

  def self.reject(lc, user)
    msg = Message.new
    return msg.set_true()
  end

  def self.get_all_packages(lc)
    puts lc
    lc.subtree.joins(:package)
  end

  def self.get_all_packages_with_detail(lc,orders=nil)
    p 'cccccccccccccccccc'

    puts(lc.id.to_s)

    puts(lc.source_location_id.to_s)
    puts(lc.user_id.to_s)
    puts(lc.container_id.to_s)
    puts(lc.type.to_s)

    p 'cccccccccccccccccc'

    query=get_all_packages(lc).select("location_containers.*,'#{lc.destinationable_id}' as whouse_id")
    query=query.order(orders) if orders
    #query.collect.each { |p| p.becomes(Package) }
  end

  def self.get_packages(lc)
    lc.descendants.joins(:package)
  end

  def self.get_forklifts(lc)
    lc.descendants.joins(:forklift)
  end

  def self.get_part_ids(lc)
    get_packages(lc).pluck('distinct(containers.part_id)')
  end

  def self.get_packages_with_detail(lc, orders=nil)
    query=get_packages(lc).select("location_containers.*,containers.*,'#{lc.destinationable_id}' as whouse_id")
    query=query.order(orders) if orders
    query.collect.each { |p| p.becomes(Package) }
  end


  def self.get_bind_forklifts_by_location(location_id, user_id=nil)
    query=LogisticsContainer.joins(:forklift).where(source_location_id: location_id)
    query=query.where(user_id: user_id) if user_id
    query
  end

  def self.count_all_packages(lc)
    lc.descendants.joins(:package).count
  end

  #---------------------------
  def self.get_all_accepted_packages(lc)
    get_all_packages_by_state(lc,MovableState::CHECKED)
  end

  def self.get_accepted_packages(lc)
    get_packages_by_state(lc, MovableState::CHECKED)
  end
  #---------------------------

  def self.count_accepted_packages(lc)
    get_accepted_packages(lc).count
  end

  #---------------------------
  def self.get_all_rejected_packages(lc)
    get_all_packages_by_state(lc,MovableState::REJECTED)
  end

  def self.get_rejected_packages(lc)
    get_packages_by_state(lc, MovableState::REJECTED)
  end
  #---------------------------

  def self.count_rejected_packages(lc)
    get_rejected_packages(lc).count
  end


  #---------------------------
  def self.get_all_packages_by_state(lc,state)
    lc.subtree.joins(:package).where(state:state)
  end

  def self.get_packages_by_state(lc, state)
    lc.descendants.joins(:package).where(state: state)
  end
  #---------------------------
end