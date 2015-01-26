class OperationMode
  AUTO=0
  MANUAL=1

  def self.display mode
    case mode
      when AUTO
        '自动'
      when MANUAL
        '手动'
    end
  end

  def self.list_menu
    data = []
    self.constants.each do |c|
      v = self.const_get(c.to_s)
      data << [self.display(v),v]
    end
    data
  end
end