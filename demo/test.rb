require_relative 'package.rb'
require 'json'

package= Package.new(package_type: PackageType::Wood)

puts package.package_type

