class MovableState
  INIT=0
  PROCESSING=1
  FINISHED=2
end

class Movable
  attr_accessor :current_position_id,:destination_id,:sender_id,:delivery_date,:receiver_id,:received_date,:state,:locked

  def initialize(args={})
    self.state = MovableState::INIT
    args.each{|k,v|}{
      self.instance_variable_set("@#{k}", v) unless v.nil?
    }
  end

  def set_out(destination_id,sender_id = nil)
    before_set_out
    self.state = MovableState::PROCESSING
    self.destination_id = destination_id
    self.delivery_date = Time.now
    if sender_id
      self.sender_id = sender_id
    end
    lock true
  end

  def before_set_out
    #check
    begin
      if self.state != MovableState::INIT
        rails "State Error:require State:#{MovableState::INIT},actual State:#{self.state}"
      end

      if self.current_position_id == destination_id
        rails "Position Error: require Position not:#{destination_id}, actual Position:#{self.current_position_id}"
      end

    rescue
    end
  end

  def arrived(receiver_id=nil)
    before_arrived
    self.state = MovableState::FINISHED
    self.received_date = Time.now
    self.current_position_id = self.destination_id
    if receiver_id
      self.receiver_id = receiver_id
    end
    lock false
  end

  def before_arrived
    #check
    begin
      if self.state != MovableState::PROCESSING
        rails "State Error:require State:#{MovableState::PROCESSING},actual State:#{self.state}"
      end

      if self.current_position_id == destination_id
        rails "Position Error: require Position not:#{destination_id}, actual Position:#{self.current_position_id}"
      end

    rescue
    end
  end

  def lock l
    self.locked = l
  end

end