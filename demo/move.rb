require_relative "action.rb"

class Move < Action

  def initialize(args={})
    args[:type] = ActionType::MOVE
    super args
  end

  def do
    # where are they?
    self.before_do
    puts "action start"
    self.state = ActionState::PROCESSING
    self.action_record.state = ActionState::PROCESSING
    self.target.move_to(self.destination_id)
    self.target.lock
    self.end_do
  end

  def finish
    self.before_finish
    puts "action end"
    self.state = ActionState::FINISHED
    self.action_record.state = ActionState::FINISHED
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