module ModemRest
  class Msg<CZ::BaseClass
    attr_accessor :led_id, :msg, :ip

    def change_led_state
      process_msg=Message.new
      begin
        response= self.get_resource(self.get_change_led_state_url).post(nil)
       puts 'response-------'
        puts response.to_json
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
      puts 'process'
      puts process_msg.to_json
      return process_msg
    end

    def get_change_led_state_url
      "http://#{self.ip}:#{SysConfigCache.led_service_port_value}/#{SysConfigCache.led_send_msg_action_value}#{get_change_led_state_msg}"
    end

    def get_change_led_state_msg
     #  _msg=self.msg.split(' ').map { |m| m.to_i.to_s(16).scan(/.{1,2}/).map { |mm| mm.rjust(2, '0') } }.join(' ')
     #_led_id= self.led_id.to_i.to_s(16).rjust(4, '0').scan(/.{2}/).join(' ')
     # msg= "#{_msg} #{_led_id}"
      #//msg=msg.split(' ').collect{|m| m='0x'+m}.join(' ')
      #puts msg

      #self.led_id=10
#      if self.led_id.to_i>255
        m="#{self.msg}  #{self.led_id}"
 #     else
  #      m="#{self.msg} 0 #{self.led_id}"
   #   end
      puts m
      URI::escape(m)
    end

    def get_resource(url)
      RestClient::Resource.new(url,
                               timeout: 100,
                      open_timeout: 100,
                               content_type: 'application/json')
    end
  end
end
