class MovableService

  #dispatch
  def self.dispatch movable,destination,user
    msg = Message.new
    begin
      ActiveRecord::Base.transaction do
        movable.des_location_id = destination.id

        unless movable.state_for(CZ::Movable::DISPATCH)
          raise MovableMessage::StateError
        end

        unless movable.dispatch(destination,user.id)
          raise MovableMessage::DispatchFailed
        end
      end
    rescue Exception => e
      return msg.set_false(e.to_s)
    end
    msg.set_true()
  end

  #receive
  def self.receive movable,user
    msg = Message.new
    begin
      ActiveRecord::Base.transaction do
        unless movable.des_location_id == user.location_id
          raise MovableMessage::CurrentLocationNotDestination
        end

        unless movable.state_for(CZ::Movable::RECEIVE)
          raise MovableMessage::StateError
        end

        unless movable.receive(user.id)
          raise MovableMessage::ReceiveFailed
        end
      end
    rescue Exception => e
      return msg.set_false(e.to_s)
    end
    msg.set_true
  end

  #check
  def self.check movable,user
    msg = Message.new
    begin
      ActiveRecord::Base.transaction do
        unless movable.des_location_id == user.location_id
          raise MovableMessage::CurrentLocationNotDestination
        end

        unless movable.state_for(CZ::Movable::CHECK)
          raise MovableMessage::StateError
        end

        unless movable.check(user.id)
          raise MovableMessage::CheckFailed
        end
      end
    rescue Exception => e
      return msg.set_false(e.to_s)
    end
    msg.set_true
  end

  #reject
  def self.reject movable,user
    msg = Message.new
    begin
      ActiveRecord::Base.transaction do
        unless movable.des_location_id == user.location_id
          raise MovableMessage::CurrentLocationNotDestination
        end

        unless movable.state_for(CZ::Movable::REJECT)
          raise MovableMessage::StateError
        end
        unless movable.reject(user.id)
          raise MovableMessage::RejectFailed
        end
      end
    rescue Exception => e
      return msg.set_false(e.to_s)
    end
    return msg.set_true()
  end
end