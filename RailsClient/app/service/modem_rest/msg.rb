module ModemRest
  class Msg<CZ::BaseClass
    attr_accessor :msg, :ip

    def send
      process_msg=Message.new

      begin
      response= self.get_resource(self.get_send_message_url).post(nil)
      if response.code==200
        msg= JSON.parse(response.body)
        if msg['Result']
          process_msg.result =msg['Result']
        else
          process_msg.content = msg['Content']
          puts "[#{Time.now.localtime}][ERROR]#{msg}"
        end
      else
        process_msg.content ='消息发送失败'
      end
      rescue => e
        process_msg.content = e.message
      end
      return process_msg
    end

    def get_send_message_url
    p=   "http://#{self.ip}:#{SysConfigCache.led_service_port_value}/#{SysConfigCache.led_send_msg_action_value}/#{self.msg}"
     puts p
      return p
    end

    def get_resource(url)
     RestClient::Resource.new(url,
                               :timeout => 5,
                               :open_timeout => 5,
                               'content_type' => 'application/json')
    end
  end
end
