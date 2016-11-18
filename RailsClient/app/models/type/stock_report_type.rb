class StockReportType
  ENTRY = MoveType.find_by_typeId('ENTRY').id
  MOVE = MoveType.find_by_typeId('MOVE').id

  def self.display type
    case type
      when ENTRY
        '入库'
      when MOVE
        '出库'
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