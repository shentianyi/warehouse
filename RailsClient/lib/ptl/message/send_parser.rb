# require 'rest-client'
require 'net/tcp_client'
require 'socket'
require 'ptl/message/confirm_parser'

module Ptl
  module Message
    class SendParser<Parser
      DEFAULT_MSG_TYPE=Ptl::Type::SendMsgType::CONTROL
      READ_TIME_OUT=nil

      # NODE_CONTROL_API='api/control'

      def initialize(job)
        self.job=job
        self.node=job.node
        self.message=encode
      end


      def process
        puts "9.  start send parser....."
        Ptl::Server.send_message(message)
      end

      def encode
        "<#{self.type}#{job.server_id}#{node.id_format}#{node.color_format}#{node.rate_format}#{node.display}#{node.job_id_format}>"
      end
    end
  end
end
