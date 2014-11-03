require_relative 'package.rb'
require_relative 'move.rb'
require_relative 'position.rb'
require 'json'

source = Position.new({name: "上海"})
destination = Position.new({name: "苏州"})

puts "initialize source:#{source.id},destination:#{destination.id}"

#
package = Package.new({package_type: PackageType::Wood})

#Position

mov = Move.new({target: package, source_id: source.id, destination_id: destination.id})

puts mov.action_record.to_json
mov.do
puts mov.action_record.to_json
mov.finish
puts mov.action_record.to_json
