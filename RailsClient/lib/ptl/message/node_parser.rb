require 'ptl/type/node_msg_type'

module Ptl
  module Message
    class NodeParser<Parser

      attr_accessor :press_type


      DEFAULT_MSG_TYPE=Ptl::Type::NodeMsgType::NODE_CONTROL

      # 0 代表短按，1代表长按
      DEFAULT_PRESS_TYPE=0
      # 节点向控制器发送指令中是否包含频率
      NODE_MESSAGE_WITH_RATED=false


      def initialize(message)

        super
        puts "3. start node parser:.....#{message}"
        self.type=message[1].to_i
        self.msg_id=message[2..7].strip

        self.node_id=message[8..11]
        #目前无法获取到状态，需要确定是否有rate
        self.curr_color=message[12]
        self.curr_display=message[13..16]
        self.curr_rate=message[17..20].to_i

        self.node=Ptl::Node.where(color: self.curr_color, rate: self.curr_rate)

        self.handle_state=message[21].to_i
        self.press_type=message[22].to_i

        self.to_state= self.press_type==0 ? Ptl::Node::ORDERED : Ptl::Node::URGENT_ORDERED

        if self.type==nil
          self.type=DEFAULT_MSG_TYPE
        end

        puts "3.1 end of init node parser: #{self.to_json}....."
      end


      def process
        # 当msg_id为空时，说明是反馈，如果不为空时说明是新的消息
        if self.msg_id.blank? || self.msg_id=='000000'
          case self.type
            # 默认是要货
            # when Ptl::Type::NodeMsgType::NODE_CONTROL,Ptl::Type::NodeMsgType::FEED_BACK
              #
              Ptl::Job.new(
                  type: self.type,
                  node_id: self.node_id,
                  curr_state: self.curr_state,
                  to_state: self.to_state,
                  curr_display: self.curr_display,
                  size: 1,
                  in_time: true
              ).in_queue
          # end
        else
          puts "led 的反馈，带有报文:#{self.msg_id}"
          if ptl_job=PtlJob.find_by_id(self.msg_id)
            if job=Ptl::Job.find_by_ptl_job(ptl_job)
              ptl_job.update_attributes(state: Ptl::State::Job::HANDLE_SUCCESS, msg: 'job exec success') if job.to_state==self.curr_state
            end
          end
        end
      end
    end


    def press_type=(v)
      @press_type= v=='>' ? DEFAULT_PRESS_TYPE : v
    end

  end
end
