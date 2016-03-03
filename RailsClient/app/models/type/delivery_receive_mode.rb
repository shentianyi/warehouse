class DeliveryReceiveMode<BaseType
  CUSTOM=100
  FORKLIFT=200
  PACKAGE = 300

  def self.display mode
    case mode
      when CUSTOM
        '按照用户选择'
      when FORKLIFT
        '按照托盘'
      when PACKAGE
        '按照包装箱'
    end
  end


end