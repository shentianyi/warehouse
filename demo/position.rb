class Position
  attr_accessor :id,:name

  def initialize(args={})
    self.id = "P#{Random.new.rand(100)}"
    self.name = args[:name]
  end
end