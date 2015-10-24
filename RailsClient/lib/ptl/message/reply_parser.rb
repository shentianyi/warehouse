module Ptl
	module Message
		class ReplyParser<SendParser

			def initialize(node_id)
				self.type='F2'
				self.node_id=node_id
				self.message=encode
			end

			def process
puts 'send reply......................................'
				begin
					res=init_client.post(nil)
					msg=JSON.parse(res.body)
					if res.code==201 || res.code==200
						puts "@@@backdata:#{msg}"
					end
				rescue =>e
					puts "replay message:#{e.message}"
				end
			end

			def encode
				xor_str="#{self.type}#{self.node_id}000000000000" 
				"FC#{xor_str}#{self.class.get_xor(xor_str)}"
			end
		end
	end
end
