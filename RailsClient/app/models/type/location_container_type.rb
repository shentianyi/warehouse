class LocationContainerType
  LOCATION=0 # base
  LOGISTICS=1
  STORE=2

  def self.get_type(type)
    self.const_get(type.upcase)
  end
end