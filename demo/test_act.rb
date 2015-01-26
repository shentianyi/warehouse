require_relative 'package.rb'
require_relative 'move.rb'
require_relative 'position.rb'
require_relative 'action_manager.rb'
require 'json'

source = Position.new({name: "A"})
destination = Position.new({name: "B"})

puts "initialize source:#{source.id},destination:#{destination.id}"

#
=begin
package = Package.new({package_type: PackageType::Wood})

ActionManager.register('move',package,source.id,destination.id)

package.action.do
package.action.finish

package.action.describe
=end

#Position

