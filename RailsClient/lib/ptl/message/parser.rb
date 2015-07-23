module Ptl
  module Message
    class Parser

      attr_accessor :message

      PHASE_REGEX=/<[0-9a-zA-Z]{68}>/
      CONFIRM_REGEX=/<[0-9a-zA-Z]{11}>/
      LED_REGEX=/<[0-9a-zA-Z]{17}>/

	  def initialize(message)
	    self.message=message
	  end

     def self.dispatch message
		 if CONFIRM_REGEX.match(message)
			 # do confirm logic
		 elsif LED_REGEX.match(message)
			 LedParser.new(message).parse
		 end
	 end

    end
  end
end
