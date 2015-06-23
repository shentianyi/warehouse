class ScrapListItemState<StateBase
  UNHANDLED = 100
  HANDLED = 200

  def self.display state
    case state
      when UNHANDLED
        '未处理'
      when HANDLED
        '已处理'
      else
        '未知'
    end
  end
end