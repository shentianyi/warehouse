require_relative 'container.rb'

class PackageType
  Paper=1
  Wood=2
end

class Package<Container
  attr_accessor :package_type

  def initialize(args={})
    super
  end
end


class Forklift<Container

end

class Delivery<Container

end