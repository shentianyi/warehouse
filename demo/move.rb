#require_relative 'action.rb'
=begin

class Movable #< Action

  def start
    before_start
    puts ".....start move"
    self.state = ActionState::PROCESSING
    self.action_record.state = ActionState::PROCESSING
    self.target.move_to self.destination_id
    end_start
  end

  def finish
    before_finish
    puts ".....finish move"
    self.state = ActionState::FINISHED
    self.action_record.state = ActionState::FINISHED
    self.target.arrived
    end_finish
  end

  def before_start
    begin
      if self.target.position_id != self.source_id
        raise "Position illegal! => current position is not in the source position for move action"
      end
    rescue
    end
  end

  def end_start
    self.target.lock
  end

  def before_finish
    #do some check here
  end

  def end_finish
    self.target.unlock
  end
end=end
