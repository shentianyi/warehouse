=begin
require_relative 'action_record.rb'

class ActionState
  INIT=0
  PROCESSING=1
  FINISHED=2

  def self.get_type(type)
    self.const_get(type)
  end
end

class ActionType
    BASE = 0
    MOVE = 1

    def self.get_type(type)
      self.const_get(type)
    end
end

#Action Base class
class Action < CZBase
  attr_accessor :id,:type,:state,:action_record,:target

  def initialize(args={})
    self.id = "A#{Random.new(10000)}"
    self.state = ActionState::INIT
    args.each do |k, v|
      self.instance_variable_set("@#{k}", v) unless v.nil?
    end
    self.action_record = ActionRecord.new(
        {
            action_id:self.id,
            action_type: self.type,
            source_id:self.source_id,
            destination_id:self.destination_id,
            container_id:self.target.id,
            state:self.state}
    )
  end
end=end
