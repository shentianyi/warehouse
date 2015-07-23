module Ptl
 module Message
  class LedParser<Parser
	  
	attr_accessor :type,:msg_id,:led_id,:curr_state,:to_state,:curr_display,:to_display,:handle_state,:press_type

	
	  # 0 代表短按，1代表长按
	  DEFAULT_PRESS_TYPE=0
	  # 节点向控制器发送指令中是否包含频率
	  LED_MESSAGE_RATED=false

    def parse(message)
		self.type=message[1].to_i
		self.msg_id=message[2,7]
		self.led_id=message[8,11]
		self.current_state=
	end
  end
 end
end
