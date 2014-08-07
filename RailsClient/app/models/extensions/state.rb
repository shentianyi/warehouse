module Extensions
  module STATE
    extend ActiveSupport::Concern
    included do
      after_save :log_state

      def log_state
        if self.state_changed?
          self.state_logs.create(state_before: self.state_was, state_after: self.state)
        end
      end

      def set_state state
        if Kernel.const_get(self.class.name+"State").can_change?self.state,state
          #self.state = state
          #self.save
          self.update(state:state)
          true
        else
          false
        end
      end
    end
  end
end