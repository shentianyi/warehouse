class Move < Action
  attr_accessor :target

  def initialize args
    super args
    this.target = args[:target]
  end

  def start

  end

  def end

  end
end