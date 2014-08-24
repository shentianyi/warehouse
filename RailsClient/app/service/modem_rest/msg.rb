module ModemRest
  class Msg<CZ::BaseClass
    attr_accessor :msg, :id, :ip

    def send
      process_msg=Message.new

      begin
      response= self.get_url.post({msg: self.msg, id: self.id})
      if response.code==201
        msg= JSON.parse(response.body)
        if msg['result']
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

    def get_url
      puts "http://#{self.ip}:#{SysConfigCache.led_service_port_value}/#{SysConfigCache.led_send_msg_action_value}"
      RestClient::Resource.new("http://#{self.ip}:#{SysConfigCache.led_service_port_value}/#{SysConfigCache.led_send_msg_action_value}",
                               :timeout => 5,
                               :open_timeout => 5,
                               'content_type' => 'application/json')
    end
  end
end