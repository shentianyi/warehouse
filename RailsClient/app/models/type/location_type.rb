class LocationType
  BASE = 0
  NORMAL = 1
  DESTINATION = 2

  def self.menu
    data = []
    self.constants.each do |c|
      v = self.const_get(c.to_s)
      data << [self.display(v),v]
    end
    data
  end

  def self.display type
    case type
      when BASE
        '基礎'
      when NORMAL
        '普通'
      when DESTINATION
        '默認目的地'
      else
        '未知'
    end
  end
end