class ReportType
  Entry = 0
  Removal = 1

  def self.display type
    case type
      when Entry
        '收货'
      when Removal
        '发货'
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