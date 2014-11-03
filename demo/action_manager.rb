require_relative 'move.rb'

class ActionManager<CZBase
	@@action_list = {}

	def self.register(type,target,source_id,destination_id)
		action = nil
		if find_action(type,target).nil?
			puts 'action nil,new move action'
			action = generate(type,target,source_id,destination_id)
		end
		target.action = action
	end

	private

	def self.generate(type,target,source_id,destination_id)
		action = nil
		case type
		when 'move'
			puts "new Move action"
			action = Move.new({target:target,source_id:source_id,destination_id:destination_id})
		end
		@@action_list[action.id]
		return action
	end

	def self.find_action(type,target)
		#this is not right,action may finished
		puts 'find action'
		@@action_list.each_value {|a|
			if a.type == type && a.target_id == target.id && a.state != ActionState::FINISHED
				return t
			end
		}
		nil
	end
end