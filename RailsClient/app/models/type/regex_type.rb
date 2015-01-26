class RegexType
  PACKAGE_LABEL=100
  ORDERITEM_LABEL=200

  def self.types
    types = []
    self.constants.each do |c|
      types << self.const_get(c.to_s)
    end
    types
  end

  def self.display(type)
    case type
      when PACKAGE_LABEL
        '包装箱标签规范'
      when ORDERITEM_LABEL
        '需求单标签规范'
    end
  end
end