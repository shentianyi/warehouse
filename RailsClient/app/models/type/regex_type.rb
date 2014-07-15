class RegexType
  PACKAGE_LABEL=100

  def self.types
    types = []
    self.constants.each do |c|
      types << self.const_get(c.to_s)
    end
    types
  end
end