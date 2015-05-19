class OrderState
  ORIGINAL = 0
  PRINTED = 1
  HANDLED = 2

  def self.display state
    case state
      when ORIGINAL
        '未处理'
      when PRINTED
        '已打印'
      when HANDLED
        '已处理'
      else
        '未知'
    end
  end
end