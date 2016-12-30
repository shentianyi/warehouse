class LedLightState
  # NORMAL = 0
  # ORDERED = 1
  # DELIVERED = 2
  # RECEIVED = 3

  NORMAL=100 #正常
  ORDERED=200 #要货
  URGENT_ORDERED=300 #紧急要货
  PICKED=400 #择货
  DELIVERED=500 #发运
  RECEIVED=600 #接受

  def self.list
    data = []
    self.constants.each do |c|
      v = self.const_get(c.to_s)
      data << [self.display(v),v]
    end
    data
  end

  def self.all
    self.constants.collect{|c| self.const_get(c.to_s)}
  end

  def self.display state
    case state.to_i
      when NORMAL
        '正常'
      when ORDERED
        '要货'
      when URGENT_ORDERED
        '紧急要货'
      when PICKED
        '择货'
      when DELIVERED
        '发运'
      when RECEIVED
        '接受'
    end
  end
end