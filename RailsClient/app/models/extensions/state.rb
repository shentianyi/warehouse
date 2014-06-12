module Extensions
  module STATE
    extend ActiveSupport::Concern
    included do
      after_save :log_state

      def log_state
        unless self.state_changed?
          self.state_logs.create(state_before: self.state_was, state_after: self.state)
        end
      end
    end
  end
end