# require 'rest-client'
# require 'net/tcp_client'
require 'socket'

module Ptl
  module Message
    class SendParser<Parser
      DEFAULT_MSG_TYPE=2 #Ptl::Type::SendMsgType::CONTROL
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
        begin
          puts "@@@server:#{SysConfigCache.led_server_value}#{SysConfigCache.led_send_msg_action_value}#{URI.encode(message)}"
          res=init_client(SysConfigCache.led_send_msg_action_value, self.message).post(nil)
          puts "@@ after post................."

          msg=JSON.parse(res.body)
          puts "@@@code:#{res.code}backdata:#{msg}:#{msg['Result'].class}"

          if res.code==201 || res.code==200
            msg=JSON.parse(res.body)
            puts "@@@backdata:#{msg}"
            if msg['Result']
              #if ptl_job= PtlJob.find_by_id(job.id)
              job.ptl_job.update_attributes(state: Ptl::State::Job::SEND_SUCCESS, msg: '发送成功')
              #end
            elsif msg['Result']
              #if ptl_job= PtlJob.find_by_id(job.id)
                job.ptl_job.update_attributes(state: Ptl::State::Job::HANDLE_FAIL, msg: msg['Content'].to_s)
              #end
            end
          end
        rescue => e
          job.ptl_job.update_attributes(state: Ptl::State::Job::HANDLE_FAIL, msg:e.message)
        end
      end

      def init_client(api, message)
        RestClient::Resource.new("#{SysConfigCache.led_server_value}#{api}#{URI.encode(message)}",
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

        # "<#{self.type}000#{node.id_format}#{node.color_format}#{node.rate_format}#{node.display}#{job.job_id_format}>"

        "<#{self.type}#{node.id_format}#{node.display}#{node.color_format}#{node.rate_format}>"
      end
    end
  end
end
