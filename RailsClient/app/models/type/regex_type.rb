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
end