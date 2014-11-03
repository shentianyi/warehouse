require_relative "action.rb"

class Move < Action

  def initialize(args={})
    args[:type] = ActionType::MOVE
    super args
  end

  def do
    self.before_do
    self.state = ActionState::PROCESSING
    self.action_record.state = ActionState::PROCESSING
    self.targets.each{|t| t.move_to self.destination_id}
    self.end_do
  end

  def finish
    self.before_finish
    self.state = ActionState::FINISHED
    self.action_record.state = ActionState::FINISHED
    self.targets.each{|t| t.arrived}
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
    self.lock_resource
  end

  def before_finish
    #do some check here
  end

  def end_finish
    self.unlock_resource
  end

  def lock_resource
    self.targets.each{|t| t.lock}
  end

  def unlock_resource
    self.targets.each{|t| t.unlock}
  end
end