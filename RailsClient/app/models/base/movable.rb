module Movable
  #include this module to your Model,make sure you have column below
  attr_accessor :current_location_id,:destination_id,:sender_id,:receiver_id,:delivery_date,:received_date

  def set_out(destination_id,sender_id = nil)

    self.destination_id = destination_id
    if sender_id
      self.sender_id = sender_id
    end
    self.delivery_date = Time.now
  end

  def arrive(receiver_id=nil)

    self.current_location_id = self.destination_id
    if receiver_id
      self.receiver_id = receiver_id
    end
    self.received_date = Time.now
  end
end