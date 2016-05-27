class CafDaysEnum
  CAF3 = 3
  CAF7 = 7

  def self.display(type)
    case type
      when CAF3
        '3天'
      when CAF7
        '7天'
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