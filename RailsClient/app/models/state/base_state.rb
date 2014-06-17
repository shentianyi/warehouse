class BaseState
  ORIGINAL = 0
  WAY = 1
  DESTINATION = 2
  RECEIVED = 3

  def self.display state
    case state
      when ORIGINAL
        '初始状态'
      when WAY
        '在途'
      when DESTINATION
        '到达'
      when RECEIVED
        '已接收'
      else
        '未知状态'
    end
  end

  def self.can_delete? state
    if state == ORIGINAL
      true
    else
      false
    end
  end

  def self.can_update? state
    if state == ORIGINAL
      true
    else
      false
    end
  end
end