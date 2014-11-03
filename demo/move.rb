require_relative 'action.rb'

class Move < Action

  def initialize(args={})
    args[:type] = ActionType::MOVE
    super args
  end

  def do
    before_do
    puts ".....do move"
    self.state = ActionState::PROCESSING
    self.action_record.state = ActionState::PROCESSING
    self.target.move_to self.destination_id
    end_do
  end

  def finish
    before_finish
    puts ".....finish move"
    self.state = ActionState::FINISHED
    self.action_record.state = ActionState::FINISHED
    self.target.arrived
    end_finish
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
    self.target.lock
  end

  def before_finish
    #do some check here
  end

  def end_finish
    self.target.unlock
  end
end