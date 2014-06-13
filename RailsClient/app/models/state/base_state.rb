module State
  class BaseState
    ORIGINAL = 0
    WAY = 1
    DESTINATION = 2

    def self.display state
      case state
        when ORIGINAL
          '初始状态'
        when WAY
          '在途'
        when DESTINATION
          '到达'
        else
          '未知状态'
      end
    end
  end
end