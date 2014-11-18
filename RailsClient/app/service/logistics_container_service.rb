class LogisticsContainerService
  def self.destroy_by_id(id)
    msg=Message.new
    if lc=LogisticsContainer.exists?(id)
      if lc.updateable?
        ActiveRecord::Base.transaction do
          lc.children.each do |c|
            puts '****************'
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
    begin
      ActiveRecord::Base.transaction do
        unless lc.source_location_id == user.location_id
          raise
        end
        lc.des_location_id = destination.id
        #
        unless lc.state_for("dispatch")
          raise
        end

        unless lc.dispatch(destination, user.id)
          raise
        end
        lc.save

        lc.children.each do |c|
          c.source_location_id = user.location_id
          c.des_location_id = destination.id
          unless c.state_for("dispatch")
            raise
          end
          dispatch(c, destination, user)
        end
      end
    rescue
      return false
    end
    return true
  end

  def self.receive(lc, user)
    begin
      ActiveRecord::Base.transaction do
        unless lc.des_location_id == user.location_id
          raise
        end

        unless lc.state_for("receive")
          raise
        end
        lc.des_location_id = user.location_id
        lc.container.update(current_positionable: user.location)
        lc.receive(user.id)
        lc.save
        lc.children.each do |c|
          unless c.state_for("receive")
            raise
          end
          c.container.current_positionable = c.destinationable
          receive(lc, user)
        end
      end
    rescue

    end
  end

  def self.check(lc, user)
    begin
      ActiveRecord::Base.transaction do
        unless lc.des_location_id == user.location_id
          raise
        end

        unless lc.state_for("check")
          raise
        end
        lc.check(user.id)
        lc.save
        lc.children.each do |c|
          unless c.state_for("check")
            raise
          end
          check(lc, user)
        end
      end
    rescue

    end
  end

  def self.reject(lc, user)
    begin
      ActiveRecord::Base.transaction do
        unless lc.des_location_id == user.location_id
          raise
        end

        unless lc.state_for("reject")
          raise
        end
        lc.reject(user.id)
        lc.save
        lc.children.each do |c|
          unless c.state_for("reject")
            raise
          end
          reject(lc, user)
        end
      end
    rescue

    end
  end
end