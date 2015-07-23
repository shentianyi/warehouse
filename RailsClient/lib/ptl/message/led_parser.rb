require 'ptl/type/led_msg_type'

module Ptl
 module Message
  class LedParser<Parser
	  
	attr_accessor :press_type

	
	  DEFAULT_MSG_TYPE=LedMsgType::CONTROLL

	  # 0 代表短按，1代表长按
	  DEFAULT_PRESS_TYPE=0
	  # 节点向控制器发送指令中是否包含频率
	  LED_MESSAGE_WITH_RATED=false
	  

    def initialize
		
		super

		self.type=message[1].to_i
		self.msg_id=message[2,7].to_i

		self.led_id=message[8,11]
		#目前无法获取到状态，需要确定是否有rate
		self.curr_color=message[12]
		self.curr_display=message[13,16]
        self.curr_rate=message[17,20].to_i
	
		self.state=Ptl::Led.where(color:self.curr_color,rate:self.curr_rate)
	
		self.handle_state=message[21].to_i
		self.press_type=message[22].to_i

		self.to_state=	  self.press_type==0 ? Ptl::Led::ORDERD : Ptl::Led::URGENT_ORDERD

		if self.type==nil
		  self.type=DEFAULT_MSG_TYPE
		end
	end


	def process
		case self.type
			# 默认是要货
			when LedMsgType::LED_CONTROLL
				#
				Ptl::Job.new(
					     led_id:self.led_id,
						 curr_state:self.curr_state,
						 to_state:self.to_state,
						 curr_display: self.current_dispaly,
						 size: 1,
						 
						 # TODO
						 # get led server from database
						 #
						 server_id:'001'
						 server_url:'http://127.0.0.1:9000'
					   ).in_queue
			end
		end
	end


	def press_type=(v)
		@press_type= v=='>' ? DEFAULT_PRESS_TYPE : v
	end

  end
 end
end
