class LocationContainerService

  # send
  # location container and its children
  def self.send lc,destination_id,sender_id=nil
    begin
      unless MovableState.pre_states(MovableState::WAY).include? lc.get_state
        rails "Movable State Error"
      end

      lc.set_out(destination_id,sender_id)
=begin #open this after lc.children method exits
      lc.children.each do |c|
        unless send(c)
          raise 'send failed'
        end
      end
=end
      lc.save
    rescue
        return false
    else
      return true
    end
  end

  def self.arrive lc,receiver_id=nil
    begin
      unless MovableState.pre_states(MovableState::ARRIVED).include? lc.get_state
        rails "State Error"
      end

      lc.arrive(receiver_id)
=begin

      lc.children.each do |c|
        arrive(c)
      end
=end

      lc.save

    rescue
      return false
    else
      return true
    end
  end


end