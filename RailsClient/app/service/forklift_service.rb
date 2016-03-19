class ForkliftService
  def self.dispatch(lc, destination, user)
    ActiveRecord::Base.transaction do
      if lc.descendants.count == 0
        return Message.new.set_false("无法发运空拖清单")
      end

      unless (m = lc.get_movable_service.dispatch(lc, destination, user)).result
        return m
      end

      lc.descendants.each { |d|
        unless (m = d.get_movable_service.dispatch(d, destination, user)).result
          return m
        end
      }

      return Message.new.set_true
    end
  end

  def self.receive(lc, user)
    ActiveRecord::Base.transaction do
      unless (m = lc.get_movable_service.receive(lc, user)).result
        return m
      end

      lc.descendants.each { |d|
        unless (m = d.get_movable_service.receive(d, user)).result
          return m
        end
      }

      return Message.new.set_true
    end
  end

  def self.confirm_receive(lc, user)
    ActiveRecord::Base.transaction do
      unless (m = lc.get_movable_service.check(lc, user)).result
        return m
      end


      lc.descendants.each { |d|
        if d.state == MovableState::ARRIVED
          unless (m = d.get_movable_service.reject(d, user)).result
            return m
          end
        end
      }

      return Message.new.set_true
    end
  end

  def self.create args, user
    msg = Message.new
    location=nil
    unless location=Location.find_by_nr(args[:destinationable_id])
      msg.content = ForkliftMessage::DestinationNotExist
      return msg
    end unless args[:destinationable_id].blank?

    ActiveRecord::Base.transaction do
      forklift = Forklift.new(user_id: user.id, location_id: user.location_id)
      if forklift.save
        lc=forklift.logistics_containers.build(source_location_id: user.location_id, user_id: user.id)
        lc.destinationable=location
        lc.save

        msg.result=true
        msg.object = lc
      else
        msg.content = forklift.errors.full_messages
      end
    end
    return msg
  end

  def self.search(condition)
    if condition && condition['records.impl_time']
      LogisticsContainer.joins(:forklift).joins(:records).where(condition)
    else
      LogisticsContainer.joins(:forklift).where(condition)
    end.distinct
  end


  def self.enter_stock user, lc, warehouse, position, fifo
    ActiveRecord::Base.transaction do
      if forklift=lc.forklift
        lc.descendants.each { |d|
           PackageService.enter_stock(user,d,warehouse,position,fifo)
        }
       return true
      else
        raise "托盘:#{params[:container_id]}不存在"
      end
    end
    return false
  end
end
