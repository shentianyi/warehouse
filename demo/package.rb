require_relative 'container.rb'
require_relative 'movable.rb'

class PackageType
  Paper=1
  Wood=2
end

class Package<Container
  attr_accessor :package_type

  #include Movable

  def initialize(args={})
    super
  end
end


class Forklift<Container

end

class Delivery<Container

end