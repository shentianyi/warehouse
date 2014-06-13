class DeliveryState<BaseState
  RECEIVED=3

  def self.display state
    case state
      when RECEIVED
        '已接收'
      else
        super
    end
  end
end