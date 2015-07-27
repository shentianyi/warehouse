module Ptl
  module Message
    class Parser

      attr_accessor :message, :type, :msg_id, :job, :node, :curr_color, :curr_state, :to_state, :curr_display, :to_display, :curr_rate, :to_rate, :handle_state

      PHASE_REGEX=/<[0-9a-zA-Z]{58}>/
      CONFIRM_REGEX=/<[0-9a-zA-Z]{11}>/
      NODE_REGEX=/<[0-9a-zA-Z]{24}>/

      def initialize(message)
        self.message=message
      end

      def self.dispatch message
        if CONFIRM_REGEX.match(message)
          ConfirmParser.new(message).process
        elsif NODE_REGEX.match(message)
          NodeParser.new(message).process
        end
      end

    end
  end
end
