class Action
  attr_accessor :id,:action_type,:position_id

  def initialize(args={})
    self.id = "A#{Random.new(10000)}"
    self.action_type = args[:action_type]
  end

  def do

  end

  def finish

  end
end