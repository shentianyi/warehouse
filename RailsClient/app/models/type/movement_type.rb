class MovementType
  MOVE = 1
  ENTRY = 2

  def self.display type
    case type
      when MOVE
        '出库'
      when ENTRY
        '入库'
    end
  end

  def self.list
    data = []
    self.constants.each do |c|
      v = self.const_get(c.to_s)
      data << [self.display(v),v]
    end
    data
  end
end