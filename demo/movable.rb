module Movable
  attr_accessor :current_position_id,:delivery_date,:received_date,:locked

  def move_to(position_id)
    self.current_position_id = position_id
    self.delivery_date = Time.now
    puts "current:#{self.current_position_id},delivery_date:#{self.delivery_date}"
    #all children to this position
    #self.children.foreach{|c| c.move_to positio}
  end

  def arrived
    self.received_date = Time.now
    puts "received_date:#{self.received_date}"
    #all children arrived
    #self.children.foreach{|c| c.arrived}
  end

  def lock
    puts "resource locked"
    self.locked = true
  end

  def unlock
    puts "resource unlocked"
    self.locked = false
  end

  def children
    []
  end
end