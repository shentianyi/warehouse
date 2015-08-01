# require 'rest-client'
# require 'net/tcp_client'
require 'socket'

module Ptl
  module Message
    class SendParser<Parser
      DEFAULT_MSG_TYPE=Ptl::Type::SendMsgType::CONTROL
      NODE_CONTROL_API='/ptl/receive'
      READ_TIME_OUT=nil


      def initialize(job)
        self.type=DEFAULT_MSG_TYPE
        puts '0.9-----new sender parser'
        self.job=job
        puts '0.9.1-----new sender parser'

        self.node=job.node
        puts '0.9.2-----new sender parser'

        self.message=encode

        puts "0.9.3-----new sender parser:#{self.message}"

      end


      def process
        # puts "9.  start send parser....."
        # Ptl::Server.send_message(message)


        res=init_client(NODE_CONTROL_API).post({
                                                  message:self.message
                                               })
        if res.code==201
          msg=JSON.parse(res.body)
          if msg['Result']=='true'
            if ptl_job= PtlJob.find_by_id(job.id)
              ptl_job.update_attributes(state: Ptl::State::Job::SEND_SUCCESS, msg: '发送成功')
            end
          elsif msg['resultCode']=='false'
            if ptl_job= PtlJob.find_by_id(job.id)
              ptl_job.update_attributes(state: Ptl::State::Job::HANDLE_FAIL, msg: msg['Content'].to_s)
            end
          end
        end

      end

      def init_client(api)
        RestClient::Resource.new("#{job.server_url}#{api}",
                                 timeout: nil,
                                 open_time_out: nil,
                                 content_type: 'application/json'
        )
      end

      def encode
        puts ':1 type'
        puts self.type
        puts ':1 id_format'
        puts node.id_format
        puts ':1 color_format'
        puts node.color_format
        puts ':1 rate_format'
        puts node.rate_format
        puts ':1 display'
        puts node.display
        puts ':1 job_id_format'
        puts job.job_id_format

        "<#{self.type}000#{node.id_format}#{node.color_format}#{node.rate_format}#{node.display}#{job.job_id_format}>"
      end
    end
  end
end
