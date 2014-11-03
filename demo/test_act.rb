require_relative 'package.rb'
require_relative 'move.rb'
require_relative 'position.rb'
require_relative 'action_manager.rb'
require 'json'

source = Position.new({name: "上海"})
destination = Position.new({name: "苏州"})

puts "initialize source:#{source.id},destination:#{destination.id}"

#
package = Package.new({package_type: PackageType::Wood})

ActionManager.register('move',package,source.id,destination.id)

package.action.do
package.action.finish

puts package.action.to_json

#Position

