class Movable
  attr_accessor :current_position,:delivery_date,:received_date

  def move_to position
    this.before_move

    this.current_position = position

    this.end_move
  end

  def before_move
    
  end

  def end_move

  end
end