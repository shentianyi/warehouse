require_relative "action.rb"
require_relative "action_type.rb"

class Move < Action
  #target -> container
  attr_accessor :target,:source_id,:destination_id

  def initialize(args={})
    args[:action_type] = ActionType::MOVE
    super args
    self.target = args[:target]
    self.source_id = args[:source_id]
    self.destination_id = args[:destination_id]
  end

  def do
    # where are they?
    self.before_do
    puts "action start"
    self.target.move_to(self.destination_id)
    self.target.lock
    self.end_do
  end

  def finish
    self.before_finish
    puts "action end"
    self.target.arrived
    self.target.unlock
    self.end_finish
  end

  def before_do
    begin
      if self.target.position_id != self.source_id
        raise "Position illegal! => current position is not in the source position for move action"
      end
    rescue
    end
  end

  def end_do

  end

  def before_finish

  end

  def end_finish

  end
end