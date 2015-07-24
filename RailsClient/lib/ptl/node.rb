module Ptl
  class Node

    attr_accessor :state, :color, :rate


    NORMAL=100
    ORDERED=200
    URGENT_ORDERED=300
    PICKED=400
    DELIVERED=500
	IN_RECEIVE=600
    RECEIVED=700

	@@state_map={
		:'100'=>{state:NORMAL,color:'G',rate:0},
		:'200'=>{state:ORDERED,color:'R',rate:0},
		:'300'=>{state:URGENT_ORDERED,color:'R',rate:200},
		:'400'=>{state:PICKED,color:'B',rate:0},
		:'500'=>{state:DELIVERED,color:'B',rate:200},
		:'600'=>{state:IN_RECEIVE,color:'G',rate:200},
		:'700'=>{state:RECEIVED,color:'G',rate:0}
	}
    
	def initialize(state)
		map=Node.find_map(state)
		self.state=map[:state]
		self.color=map[:color]
		self.rate=map[:rate]
	end


	def self.where(args={})
		@@state_map.values.each do |v|
			puts v

			finded=true

			args.each do |k,vv|
				puts "#{k}====#{vv}----#{v[k]}"
				if	v[k]!=vv
					(finded=false)
					break
				end
			end
				puts "----------#{v}"
				return self.find(v[:state]) if finded

		end
	end

	def self.find_map(state)
		@@state_map[state.to_s.to_sym] || raise('No State Error')
	end

	def self.find(state)
		Node.new(state)
	end

	def color_format
		self.color
	end

	def rate_format
		'%04d' % self.rate
	end

	def self.encode_display(to_state,curr_dispaly='',size=1)
		case to_state
		when NORMAL
			'0000'
		when ORDERED
			"#{curr_dispaly[0,1]}#{ '%02d' % (curr_dispaly[2,3].to_i+size)}"
		when URGENT_ORDERED
            "#{'%02d' % (curr_dispaly[0,1].to_i+size)}#{ '%02d' % (curr_dispaly[2,3].to_i+size)}"
		when PICKED,DELIVERED
			curr_dispaly
		when RECEIVED
           "#{curr_dispaly[0,1]}#{ '%02d' % (curr_dispaly[2,3].to_i+size)}"
		end
	end

  end
end
