class ContainerType
  Package=1
  Forklift=2
  Delivery=3

  def self.get_type(type)
    self.const_get(type)
  end
end

module Container
  attr_accessor :children, :parent, :ancestors

end
