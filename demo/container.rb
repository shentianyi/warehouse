require_relative 'gen.rb'

class ContainerType
  Package=1
  Forklift=2
  Delivery=3

  def self.get_type(type)
    self.const_get(type)
  end
end

class Container
  attr_accessor :id, :type, :creator, :max_quantity
  @@containers={}

  def initialize(args={})
    self.id=Gen.get_container_id
    self.creator = rand(100)
    self.max_quantity = rand(1000)
    args.each do |k, v|
      self.instance_variable_set("@#{k}", v) unless v.nil?
    end
    self.type=ContainerType.get_type(self.class.name)
  end

  def all
    @@containers.values
  end

  def create
    @@containers[self.id]=self
  end
end

