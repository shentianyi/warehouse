class ContainerType
  PACKAGE=1
  FORKLIFT=2
  DELIVERY=3

  @@type_name = {
      PACKAGE => 'package',
      FORKLIFT => 'forklift',
      DELIVERY => 'delivery'
  }

  def self.get_type(type)
    self.const_get(type.upcase)
  end

  def self.get_type_name(type)
    @@type_name[type]
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