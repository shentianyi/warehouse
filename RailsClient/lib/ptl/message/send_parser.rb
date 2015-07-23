require 'ptl/led'
require 'ptl/type/send_msg_type'


module Ptl
  module Message
	  class SendParser<Parser
		  DEFAULT_MSG_TYPE=SendMsgType::CONTROLL

		  def initialize(job)
		    self.job=job 
			self.message=encode
			if self.type==nil
			 self.type=DEFAULT_MSG_TYPE
			end
		  end

		  def process
			  
		  end

		  def encode
			  led=Ptl::Led.find(job.to_state)

			  "<#{self.type}>#{job.server_id}#{job.led_id}#{Ptl::Led.find(job.to_state).colro}"
		  end
	  end
  end
end
