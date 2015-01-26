class FMovableService < MovableService
  def self.check(movable,user)
    msg = Message.new

    begin
      ActiveRecord::Base.transaction do
        unless movable.des_location_id == user.location_id
          raise MovableMessage::CurrentLocationNotDestination
        end

        sum = LogisticsContainerService.get_packages(movable).count
        acceptes = LogisticsContainerService.get_packages_by_state(movable,MovableState::CHECKED).count

        if sum==acceptes
          unless movable.state_for(CZ::Movable::CHECK)
            raise MovableMessage::StateError
          end
        elsif sum > acceptes
          unless movable.state_for(CZ::Movable::CHECK)
            raise MovableMessage::StateError
          end
        end

        unless movable.check(user.id)
          raise MovableMessage::ReceiveFailed
        end

        #movable.update(current_positionable: movable.destinationable)
        movable.container.update(current_positionable: movable.destinationable)
      end
    rescue Exception => e
      return msg.set_false(e.to_s)
    end
    msg.set_true
  end
end