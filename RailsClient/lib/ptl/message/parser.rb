module Ptl
  module Message
    class Parser

      attr_accessor :node_redis_key, :message, :type, :msg_id, :job, :node, :led, :node_id, :state, :curr_color, :curr_state, :to_state, :curr_display, :to_display, :curr_rate, :to_rate, :handle_state, :server_id

      PHASE_REGEX=/<2[0-9a-zA-Z\s]{11}>/
      NODE_REGEX=/<1[0-9a-zA-Z\s]{10}>/
      CONFIRM_REGEX=/<F[0-9a-zA-Z\s]{10}>/

      def initialize(message)
        self.message=message
      end

      def self.dispatch message
        #TODO Add message filter

        puts "2. dispatch message : #{message}"
        if NODE_REGEX.match(message)
          NodeParser.new(message).process
        elsif CONFIRM_REGEX.match(message)
          ConfirmParser.new(message).process
        end
      end

      def node_redis_key
        @node_redis_key||= "last_message_key:#{self.node_id}"
      end

    end
  end
end
