class OrderItemState<StateBase
  INIT=0
  OUT_OF_STOCK=1
  FINISHED=2

  def self.display state
    case state
      when INIT
        '未处理'
      when OUT_OF_STOCK
        '缺货'
      when FINISHED
        '已备货'
    end
  end
end
