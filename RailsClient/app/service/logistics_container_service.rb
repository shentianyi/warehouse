class LogisticsContainerService
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

  def self.dispatch(lc, destination, user)
    msg = Message.new
    begin
      ActiveRecord::Base.transaction do
        #以后可能不需要检查
        unless lc.source_location_id == user.location_id
          raise MovableMessage::SourceLocationError
        end
        lc.des_location_id = destination.id
        #
        unless lc.state_for(CZ::Movable::DISPATCH)
          raise MovableMessage::StateError
        end

        unless lc.dispatch(destination, user.id)
          raise MovableMessage::DispatchFailed
        end
        lc.save

        #lc.children.each do |c|
        #  c.source_location_id = user.location_id
        #  c.des_location_id = destination.id
        #  unless c.state_for(CZ::Movable::DISPATCH)
        #    raise MovableMessage::StateError
        #  end
        #  dispatch(c, destination, user)
        #end
        lc.descendants.each do |c|
          unless c.source_location_id == user.location_id
            raise MovableMessage::SourceLocationError
          end
          c.des_location_id = destination.id

          unless c.state_for(CZ::Movable::DISPATCH)
            raise MovableMessage::StateError
          end

          unless c.dispatch(destination, user.id)
            raise MovableMessage::DispatchFailed
          end
          c.save
        end
      end
    rescue Exception => e
      return msg.set_false(e.to_s)
    end
    return msg.set_true()
  end

  def self.receive(lc, user)
    msg = Message.new
    begin
      ActiveRecord::Base.transaction do
        unless lc.des_location_id == user.location_id
          raise MovableMessage::CurrentLocationNotDestination
        end

        puts "-#################{lc.state}"
        unless lc.state_for(CZ::Movable::RECEIVE)
          raise MovableMessage::StateError
        end
        #lc.des_location_id = user.location_id
        lc.container.update(current_positionable: user.location)
        lc.receive(user.id)
        lc.save
        #lc.children.each do |c|
        #  unless c.state_for(CZ::Movable::RECEIVE)
        #    raise MovableMessage::StateError
        #  end
        #  c.container.current_positionable = c.destinationable
        #  receive(lc, user)
        #end

        lc.descendants.each do |c|
          unless c.des_location_id == user.location_id
            raise MovableMessage::CurrentLocationNotDestination
          end

          unless c.state_for(CZ::Movable::RECEIVE)
            raise MovableMessage::StateError
          end
          #不调用
          #c.container.update(current_positionable: user.location)
          #的原因是因为，forklift的current_positionable是whouse_id，不需要更新为用户的location
          c.receive(user.id)
          c.save
        end
      end
    rescue Exception => e
      return msg.set_false(e.to_s)
    end
    return msg.set_true()
  end

  def self.check(lc, user)
    msg = Message.new
    begin
      ActiveRecord::Base.transaction do
        unless lc.des_location_id == user.location_id
          raise MovableMessage::CurrentLocationNotDestination
        end

        unless lc.state_for(Movable::CHECK)
          raise MovableMessage::StateError
        end
        lc.check(user.id)
        lc.save
        lc.descendants.each do |c|
          unless c.des_location_id == user.location_id
            raise MovableMessage::CurrentLocationNotDestination
          end

          unless c.state_for(Movable::CHECK)
            raise MovableMessage::StateError
          end

          c.chcek(user.id)
          c.save
        end
      end
    rescue Exception => e
      return msg.set_false(e.to_s)
    end
    return msg.set_true()
  end

  def self.reject(lc, user)
    msg = Message.new
    begin
      ActiveRecord::Base.transaction do
        unless lc.des_location_id == user.location_id
          raise MovableMessage::CurrentLocationNotDestination
        end

        unless lc.state_for(Movable::REJECT)
          raise MovableMessage::StateError
        end
        lc.reject(user.id)
        lc.save
        lc.descendants.each do |c|
          unless c.des_location_id == user.location_id
            raise MovableMessage::CurrentLocationNotDestination
          end

          unless c.state_for(Movable::REJECT)
            raise MovableMessage::StateError
          end

          c.reject(user.id)
          c.save
        end
      end
    rescue Exception => e
      return msg.set_false(e.to_s)
    end
    return msg.set_true()
  end


  def self.get_packages(lc)
    lc.descendants.joins(:package)
  end

  def self.get_part_ids(lc)
    get_packages(lc).pluck('distinct(containers.part_id)')
  end

  def self.get_packages_with_detail(lc, orders=nil)
    query=get_packages(lc).select("containers.*,location_containers.*,'#{lc.destinationable_id}' as whouse_id")
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

  def self.count_accepted_packages(lc)
    lc.descendants.joins(:package).where(state: MovableState::CHECKED).count
  end
end