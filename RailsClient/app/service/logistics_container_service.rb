class LogisticsContainerService
  def self.destroy_by_id(id)
    msg=Message.new
    if lc=LogisticsContainer.exists?(id)
      if lc.updateable?
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
        unless lc.state_for("dispatch")
          raise MovableMessage::StateError
        end

        unless lc.dispatch(destination, user.id)
          raise MovableMessage::DispatchFailed
        end
        lc.save

        lc.children.each do |c|
          c.source_location_id = user.location_id
          c.des_location_id = destination.id
          unless c.state_for("dispatch")
            raise MovableMessage::StateError
          end
          dispatch(c, destination, user)
        end
      end
    rescue Exception => e
     msg.set_false(e.to_s)
    end
    return msg
  end

  def self.receive(lc, user)
    msg = Message.new
    begin
      ActiveRecord::Base.transaction do
        unless lc.des_location_id == user.location_id
          raise MovableMessage::CurrentLocationNotDestination
        end

        unless lc.state_for("receive")
          raise MovableMessage::StateError
        end
        lc.des_location_id = user.location_id
        lc.container.update(current_positionable: user.location)
        lc.receive(user.id)
        lc.save
        lc.children.each do |c|
          unless c.state_for("receive")
            raise MovableMessage::StateError
          end
          c.container.current_positionable = c.destinationable
          receive(lc, user)
        end
      end
    rescue Exception => e
     msg.set_false(e.to_s)
    end
    return msg
  end

  def self.check(lc, user)
    msg = Message.new
    begin
      ActiveRecord::Base.transaction do
        unless lc.des_location_id == user.location_id
          raise MovableMessage::CurrentLocationNotDestination
        end

        unless lc.state_for("check")
          raise MovableMessage::StateError
        end
        lc.check(user.id)
        lc.save
        lc.children.each do |c|
          unless c.state_for("check")
            raise MovableMessage::StateError
          end
          check(lc, user)
        end
      end
    rescue Exception => e
      msg.set_false(e.to_s)
    end
    return  msg
  end

  def self.reject(lc, user)
    begin
      ActiveRecord::Base.transaction do
        unless lc.des_location_id == user.location_id
          raise MovableMessage::CurrentLocationNotDestination
        end

        unless lc.state_for("reject")
          raise MovableMessage::StateError
        end
        lc.reject(user.id)
        lc.save
        lc.children.each do |c|
          unless c.state_for("reject")
            raise MovableMessage::StateError
          end
          reject(lc, user)
        end
      end
    rescue Exception => e
      msg.set_false(e.to_s)
    end
    return msg
  end

  def self.find_by_container_type(type,args)
    LogisticsContainer.joins(:container).where("containers.type = ?",type).where(args).all
  end
end