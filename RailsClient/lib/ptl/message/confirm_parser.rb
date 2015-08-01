module Ptl
	module Message
		class ConfirmParser<Parser
			def initialize(message)
				puts '***start confirm message......'
				self.type=message[1].to_i
				puts '***start confirm message......'+self.type.to_s

				self.msg_id=message[2..7].strip
				puts '***start confirm message......'+self.msg_id.to_s

				self.server_id=message[8..10]
				puts '***start confirm message......'+self.server_id.to_s

				self.handle_state=message[11].to_i
				puts '***start confirm message......'+self.handle_state.to_s

			end

			def process
				puts '******************start to update msg'+self.msg_id
				if job=PtlJob.find_by_id(self.msg_id)
					puts '*********find job'
					puts "**************before update: #{job.state}"
					puts "**************state: #{get_job_state}"
					job.update_attributes(state:get_job_state,msg: ConfirmMsgType.msg(self.handle_state))
					puts "**************after update: #{job.state}"
				end
			end

			def get_job_state
				case self.handle_state
				when ConfirmMsgType::SEND_SUCCESS
					Ptl::State::Job::SEND_SUCCESS
				else
					Ptl::State::Job::HANDLE_FAIL
				end
			end
		end
	end
end
