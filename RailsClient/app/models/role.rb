class Role
	RoleMethods=[:admin?,:manager?,:sender?,:receiver?]

	@@roles={
		:'100' => {:name => 'admin', :display => 'Admin'},
		:'200' => {:name => 'manager', :display => 'Manager'},
		:'300' => {:name => 'sender', :display => 'Sender'},
		:'400' => {:name => 'receiver', :display => 'Receiver'},
		:'500' => {:name => 'receiver', :display => 'Stocker'}
	}

	class<<self
		RoleMethods.each do |m|
			define_method(m) { |id|
				@@roles[id_sym(id)][:name]==m.to_s.sub(/\?/, '')
			}
		end
		@@roles.each do |key,value|
			define_method(value[:name]){
				key.to_s.to_i
			}
		end
	end

	def self.display id
		@@roles[id_sym(id)][:name]
	end

	def self.id_sym id
		id.to_s.to_sym
	end

	def self.role_menu
		#@@roles.each_with_key |key,value|

		#end
	end
end
