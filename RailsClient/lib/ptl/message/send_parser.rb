# require 'rest-client'
require 'socket'
require 'ptl/message/confirm_parser'

module Ptl
  module Message
    class SendParser<Parser
      DEFAULT_MSG_TYPE=Ptl::Type::SendMsgType::CONTROL
      # NODE_CONTROL_API='api/control'
      attr_accessor :server, :request, :response

      def initialize(server_info)
        server_info=server_info.split(':')
        server=TCPSocket.open(server_info[0], server_info[1])

        @server = server
        @request = nil
        @response = nil
        listen
        # sends
        # @request.join
        # @response.join
        # @request.join

        # self.job=job
        # self.node=job.node
        # self.message=encode
        # if self.type==nil
        #   self.type=DEFAULT_MSG_TYPE
        # end
        #
        # server_info=self.job.server_url.split(':')
        # self.server=TCPSocket.open(server_info[0], server_info[1])
        # self.request=nil
        # self.response=nil
        puts "8.  after init send parser ....."
        # @response.join
      end

      def listen
        @response=Thread.new do
          loop {
            msg=@server.gets.chomp
            PtlJob.create(params:msg)
            puts "9: get msg.....#{msg}"
          }
        end
      end

      def close
        @server.close
      end

      def sends
          @server.puts('msgssss')
      end


      def process
        puts "9.  start send parser....."

        # res=init_client(NODE_CONTROL_API).post({
        #                                            Command: self.message,
        #                                            Transaction: true
        #                                        })

        # res=init_client(NODE_CONTROL_API).post(:content_type => :json, :accept => :json)
        #
        # if res.code==201
        #   msg=JSON.parse(res.body)
        #   if msg['resultCode']=='0'
        #     #
        #     # TODO
        #     # 目前使用第一个msg
        #     Ptl::Message::NodeParser.new(msg['Feedback'][0]).process
        #   elsif msg['resultCode']=='1'
        #     if ptl_job= PtlJob.find_by_id(job.id)
        #       ptl_job.update_attributes(state: Ptl::State::Job::HANDLE_FAIL, msg: msg['Msg'].to_s)
        #     end
        #   end
        # end

      end

      def encode
        "<#{self.type}#{job.server_id}#{node.id_format}#{node.color_format}#{node.rate_format}#{node.display}#{node.job_id_format}>"
      end

      # def init_client(api)
      #   RestClient::Resource.new("#{job.server_url}#{api}?Command=#{ URI::encode self.message}&Transaction=true",
      #                            timeout: nil,
      #                            open_time_out: nil,
      #                            content_type: 'application/json'
      #   )
      # end
    end
  end
end
