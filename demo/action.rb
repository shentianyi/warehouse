class Action
  attr_accessor :id,:action_type,:location_id

  def initialize args
    this.action_type = args[:action_type]
  end

  def start

  end

  def end

  end
end