require 'rest-client'
require 'ptl/message/confirm_parser'
module Ptl
  module Message
    class SendParser<Parser
      DEFAULT_MSG_TYPE=SendMsgType::CONTROL
      NODE_CONTROL_API='api/control'

      def initialize(job)
        self.job=job
        self.node=job.node
        self.message=encode
        if self.type==nil
          self.type=DEFAULT_MSG_TYPE
        end
      end

      def process
        res=init_client(NODE_CONTROL_API).post({
                                                   Command: self.message,
                                                   Transaction: true
                                               })
        if res.code==201
          msg=JSON.parse(res.body)
          if msg['resultCode']=='0'
            Ptl::Message::ConfirmParser.new(self.job, msg['Feedback']).process
          elsif msg['resultCode']=='1'
            if ptl_job= PtlJob.find_by_id(job.id)
              ptl_job.update_attributes(state: Ptl::State::Job::HANDLE_FAIL, msg: msg['Msg'].to_s)
            end
          end
        end

      end

      def encode
        "<#{self.type}#{job.server_id}#{node.id_format}#{node.color_format}#{node.rate_format}#{node.display}#{node.job_id_format}>"
      end

      def init_client(api)
        RestClient::Resource.new("#{job.server_url}#{api}",
                                 timeout: nil,
                                 open_time_out: nil,
                                 content_type: 'application/json'
        )
      end
    end
  end
end
