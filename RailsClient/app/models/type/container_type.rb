class ContainerType
  PACKAGE=1
  FORKLIFT=2
  DELIVERY=3

  def self.get_type(type)
    self.const_get(type.upcase)
  end
end