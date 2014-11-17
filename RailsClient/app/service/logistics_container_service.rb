class LogisticsContainerService
  def self.dispatch lc, destination, user
    begin
      ActiveRecord::Base.transaction do
        lc.source_location_id = user.location_id
        lc.des_location_id = destination.id
        #
        unless lc.state_for("dispatch")
          raise
        end

        unless lc.dispatch(destination, user.id)
          raise
        end

        lc.child.each do |c|
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

  def self.receive lc, user
    begin
      ActiveRecord::Base.transaction do

        unless lc.state_for("receive")
          raise
        end
        lc.container.current_positionable = lc.destinationable
        lc.receive(user.id)
        lc.child.each do |c|
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
        unless lc.state_for("check")
          raise
        end
        lc.check(user.id)
        lc.child.each do |c|
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
        unless lc.state_for("reject")
          raise
        end
        lc.reject(user.id)
        lc.child.each do |c|
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