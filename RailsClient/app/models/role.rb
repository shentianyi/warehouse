class Role
	RoleMethods=[:admin?,:manager?,:sender?,:receiver?]

	@@roles={
		:'100' => {:name => 'admin', :display => (I18n.t 'system.role.admin')},
		:'200' => {:name => 'manager', :display => (I18n.t 'system.role.manager')},
		:'300' => {:name => 'sender', :display => (I18n.t 'system.role.sender')},
		:'400' => {:name => 'receiver', :display => (I18n.t 'system.role.receiver')},
		:'500' => {:name => 'stocker', :display => (I18n.t 'system.role.stocker')}
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
		@@roles[id_sym(id)][:display]
	end

	def self.id_sym id
		id.to_s.to_sym
	end

	def self.menu
		roles = []
		@@roles.each {|key,value|
			roles <<[value[:display],key.to_s]
		}
		roles
	end
end
