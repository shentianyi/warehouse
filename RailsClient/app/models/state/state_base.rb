class StateBase
  def self.display state
    ''
  end

  def self.list
    data = []
    self.constants.each do |c|
      v = self.const_get(c.to_s)
      data << [self.display(v), v]
    end
    data
  end
end