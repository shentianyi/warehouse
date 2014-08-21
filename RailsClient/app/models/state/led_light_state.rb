class LedLightState
  NORMAL = 0
  ORDERED = 1
  DELIVERED = 2
  RECEIVED = 3

  def self.list
    data = []
    self.constants.each do |c|
      v = self.const_get(c.to_s)
      data << [self.display(v),v]
    end
    data
  end

  def self.display state
    case state
      when NORMAL
        'Normal'
      when ORDERED
        'Ordered'
      when DELIVERED
        'Delivered'
      when RECEIVED
        'Received'
    end
  end
end