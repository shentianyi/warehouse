module Movable
  #include this module to your Model,make sure you have column below
  attr_accessor :current_position_id,:sender_id,:receiver_id,:delivery_date,:received_date,:state,:locked,:destination_id

  def setout(destination_id)

  end

  def before_setout

  end

  def arrived

  end

  def before_arrived

  end
end