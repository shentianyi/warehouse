module Ptl
  module Message
    class Parser

      attr_accessor :message,:type,:msg_id,:node_id,:curr_state,:to_state,:curr_display,:to_dispaly,:curr_rate,:to_rate,:handle_state

      PHASE_REGEX=/<[0-9a-zA-Z]{68}>/
      CONFIRM_REGEX=/<[0-9a-zA-Z]{11}>/
      NODE_REGEX=/<[0-9a-zA-Z]{24}>/

	  def initialize(message)
	    self.message=message
		#self.parse
	  end

     def self.dispatch message
		 if CONFIRM_REGEX.match(message)
			 # do confirm logic
		 elsif NODE_REGEX.match(message)
			 NodeParser.new(message).process
		 end
	 end

    end
  end
end
