module Ptl
  module Message
    class NodeParser<Parser

      attr_accessor :press_type


      DEFAULT_MSG_TYPE=1

      def initialize(message)

        super
        puts "3. start node parser:.....#{message}"
        self.type=message[1].to_i
        self.node_id=message[2..5]
        self.curr_display =message[6..9]
        self.curr_color=message[10]
        self.curr_rate=message[11].to_i
        self.node=Ptl::Node.where(color: self.curr_color, rate: self.curr_rate)

        puts "3.1 end of init node parser: #{self.to_json}....."
      end


      def process
        if (self.type==1) && (led=Led.find_by_id(self.node_id))
          # unless led.led_display==self.curr_display
          # o1=led.led_display[0..1].to_i
          #  o2=led.led_display[2..3].to_i
          n1=self.curr_display[0..1].to_i
          n2=self.curr_display[2..3].to_i
          urgent_size=n1 #(n1-o1).abs
          normal_size=n2-n1 #(n2-o2-urgent_size).abs
          #$redis.set led.id,self.curr_display
          if (cd=$redis.hgetall(node_redis_key)).blank?
            $redis.hmset(node_redis_key, 'curr_display', self.curr_display, 'date', Time.now)
          else
            return nil if cd['curr_display']==self.curr_display && (Time.parse(cd['date'])+1.minute)>Time.now
            $redis.hmset(node_redis_key, 'curr_display', self.curr_display, 'date', Time.now)
          end
          self.to_state=urgent_size>0 ? Ptl::Node::URGENT_ORDERED : Ptl::Node::ORDERED
          puts urgent_size
          puts normal_size

          if urgent_size>0 || normal_size>0
            Ptl::Job.new(
                type: self.type,
                node_id: self.node_id,
                curr_state: self.curr_state,
                to_state: self.to_state,
                curr_display: led.led_display, #"#{o1+urgent_size}#{o2+urgent_size}",
                # to_display: self.curr_display,
                urgent_size: urgent_size,
                size: normal_size,
                in_time: true
            ).in_queue
          end


          # end
        end


      end
    end

  end
end
