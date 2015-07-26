require 'rest-client'
module Ptl
  class PhaseMachine
	  attr_accessor :job

	  def initialize(job)
	   self.job=job
	  end

	  def process
		  display=nil

		  begin
			  log.info("start process job:#{job.id}")
			  case job.to_state
			  when PTL::Node::ORDERD
				  # TODO
				  # call create order items api
				  # params led
				  #
				 result=true # api
				 if result
					 
				 end
			  end
		  rescue => e
			  log.error(e.message)
		  end
	  end

  end
end
