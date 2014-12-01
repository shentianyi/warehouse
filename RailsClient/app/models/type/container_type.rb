class ContainerType
  PACKAGE=1
  FORKLIFT=2
  DELIVERY=3

  def self.get_type(type)
    self.const_get(type.upcase)
  end

  def self.display(type)
    case type
      when PACKAGE
        'package'
      when FORKLIFT
        'forklift'
      when DELIVERY
        'delivery'
    end
  end
end