module Movable
  attr_accessor :current_position_id,:delivery_date,:received_date,:locked

  def move_to(position_id)
    self.current_position_id = position_id
    self.delivery_date = Time.now
    #all children to this position
  end

  def arrived
    self.received_date = Time.now
    #all children arrived
  end

  def lock
    self.locked = true
  end

  def unlock
    self.locked = false
  end

  def children
    []
  end
end