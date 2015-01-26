class ImplUserType
  SENDER = 0
  RECEIVER = 1
  EXAMINER = 2
  REJECTOR = 3

  def self.display(type)
    case type
      when SENDER
        '发送人员'
      when RECEIVER
        '收货人员'
      when EXAMINER
        '质检人员'
      when REJECTOR
        '拒收人员'
    end
  end

  def self.display_action(type)
    case type
      when SENDER
        '发送'
      when RECEIVER
        '接收'
      when EXAMINER
        '质检通过'
      when REJECTOR
        '拒收'
    end
  end

  def self.list_menu
    data = []
    self.constants.each do |c|
      v = self.const_get(c.to_s)
      data << [self.display(v),v]
    end
    data
  end

  def self.list_action_menu
    data = []
    self.constants.each do |c|
      v = self.const_get(c.to_s)
      data << [self.display_action(v),v]
    end
    data
  end
end