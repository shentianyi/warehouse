class ImplName
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
end