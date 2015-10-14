module Ptl
  module Message
    class ConfirmParser<Parser
      def initialize(message)
        self.type=message[1]
        self.node_id=message[2..5]
        self.curr_display =message[6..9]
        self.curr_color=message[10]
        self.curr_rate=message[11].to_i
        self.node=Ptl::Node.where(color: self.curr_color, rate: self.curr_rate)

      end

      def process
        puts '******************start to update msg'+self.msg_id
        if job=PtlJob.find_by_id(self.msg_id)
          puts '*********find job'
          puts "**************before update: #{job.state}"
          puts "**************state: #{get_job_state}"
          job.update_attributes(state: get_job_state, msg: Ptl::Type::ConfirmMsgType.msg(self.handle_state))
          puts "**************after update: #{job.state}"
        end
      end

      def get_job_state
        case self.handle_state
          when Ptl::Type::ConfirmMsgType::HANDLE_SUCCESS
            Ptl::State::Job::HANDLE_SUCCESS
          when Ptl::Type::ConfirmMsgType::SEND_SUCCESS
            Ptl::State::Job::SEND_SUCCESS
          else
            Ptl::State::Job::HANDLE_FAIL
        end
      end
    end
  end
end
