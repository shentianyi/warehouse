class LogisticsContainerService
  def self.dispatch lc, destination, user
    begin
      lc.dispatch(destination,user.id)
      lc.children.each do |c|
        unless c.state_for("dispatch")
          raise
        end
        dispatch(c, destination, user)
      end
    rescue

    end
  end

  def self.receive lc,user
    begin
      lc.receive(user.id)
        lc.children.each do |c|
          unless c.state_for("receive")
            raise
          end
          receive(lc,user)
        end
    rescue

    end
  end

  def self.check(lc,user)
    begin
      lc.check(user.id)
      lc.children.each do |c|
        unless c.state_for("check")
          raise
        end
        check(lc,user)
      end
    end
  end

  def self.reject(lc,user)
    begin
      lc.reject(user.id)
      lc.children.each do |c|
        unless c.state_for("reject")
          raise
        end
        reject(lc,user)
      end
    end
  end
end