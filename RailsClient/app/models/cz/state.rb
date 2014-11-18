#base state
module CZ
  module State
    INIT = 0
    LOCK = 1

    #who include this should have base_state function
    def copyable?
      if self.base_state == LOCK
        false
      else
        true
      end
    end

    def can?(action)
      case action
        when 'delete'
        when 'update'
          if self.base_state == LOCK
            return false
          else
            return true
          end
      end
      false
    end

    def updateable?
      true
    end
  end
end
