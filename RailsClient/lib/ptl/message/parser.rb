module Ptl
  module Message
    class Parser

      attr_accessor :node_redis_key, :message, :type, :msg_id, :job, :node, :led, :node_id, :state, :curr_color, :curr_state, :to_state, :curr_display, :to_display, :curr_rate, :to_rate, :handle_state, :server_id,:fcs,:fcs_check

      NODE_REGEX=/FC02[0-9a-zA-Z]{18}/
      CONFIRM_REGEX=/FCF3[0-9a-zA-Z]{18}/

      def initialize(message,fcs_check=true)
        self.message=message

		self.fcs=message[-2..-1]
		self.fcs_check=fcs_check
      end

	  # FC020010F00107EE030108
	  # FC020001F00100010301F1
      def self.dispatch message
        #TODO Add message filter

        puts "2. dispatch message : #{message}"
        if NODE_REGEX.match(message)
         np=NodeParser.new(message)
		 ReplyParser.new(np.node_id).process
		 np.process
        elsif CONFIRM_REGEX.match(message)
          ConfirmParser.new(message).process
        end
      end

      def node_redis_key
        @node_redis_key||= "last_message_key:#{self.node_id}"
      end

	  def curr_display=v
		  puts '----------------'
		  @curr_display= '%04d' % v.to_i(16)
	  end

	  def curr_dispaly
	   @curr_display
	  end

	  def fcs_check?
	   @fcs_check
	  end

	  def process
		  puts 'process.........'
		  if fcs_check?
			  return nil unless do_fcs_check
		  end
	  end

	  def do_fcs_check
	  puts 'do fcs check.....' 
		  #xor=self.message[2..self.message.length-3].bytes.partition.each_with_index{|c,i| i.even?}.map{|a| a.inject(:^).chr}.join 
          xor=self.message[2..self.message.length-3].chars.partition.each_with_index{|c,i| i.even?}.map{|a| a.inject{|r,aa| (r.hex ^ aa.hex).to_s(16)  }}.join 

		  puts "#{self.fcs} --- vs --- #{xor}"
		  self.fcs==xor
	  end
	  
    end
  end
end
