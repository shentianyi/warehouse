#require 'ptl/led'
#require 'ptl/type/send_msg_type'


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
			  node=Ptl::Node.find(job.to_state)

			  "<#{self.type}>#{job.server_id}#{job.node_id}#{job.color}"
		  end
	  end
  end
end
