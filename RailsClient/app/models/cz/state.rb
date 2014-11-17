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

    def deletable?
      if self.base_state == 0
        true
      else
        false
      end
    end
  end
end
