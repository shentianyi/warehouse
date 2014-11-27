class FMovableService < MovableService
  def self.receive(movable,use)
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

        movable.update(current_positionable: movable.destinationable)
      end
    rescue Exception => e
      return msg.set_false(e.to_s)
    end
    msg.set_true
  end
end