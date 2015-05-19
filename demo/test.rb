require_relative 'package.rb'
require_relative 'part.rb'
require 'json'
## test package
# package= Package.new(package_type: PackageType::Wood)
# package.create
# puts package.package_type

## test load part
# uuids=['u1', 'u2', 'u3', 'u4']
# parts=[]
# for i in 0..9
#   part=Part.new
#   part.id=i
#   part.name = "P#{i}"
#   parts<<part
#   part.load({container: package, date: Time.now, quantity: rand(1000), uuid: uuids[rand(4)]})
# end
# ContainerGood.all.each { |cd| puts "#{cd.loadable_id}:#{cd.uuid}" }

# test container add
p1=Package.new(package_type: PackageType::Wood, name: 'P1').create
p2=Package.new(package_type: PackageType::Paper, name: 'P2').create
p3=Package.new(package_type: PackageType::Paper, name: 'P3').create
f1=Forklift.new(name: 'F1').create
f1.add(p1)
f1.add(p2)
f1.add(p3)


p4=Package.new(package_type: PackageType::Wood, name: 'P4').create
p5=Package.new(package_type: PackageType::Paper, name: 'P5').create
f2=Forklift.new(name: 'F2').create
f2.add(p4)
f2.add(p5)

d1=Delivery.new(name: 'D1').create
d1.add(f1)
d1.add(f2)

# p1.ancestors.values.each{|a| puts a.name}
# puts f1.ancestors.values
#
f3=Forklift.new(name: 'F3').create
d1.add(f3)
p6=Package.new(package_type: PackageType::Paper, name: 'P6').create
f3.add(p6)

# f3.ancestors.values.each { |a| puts a.name }
# p6.ancestors.values.each { |a| puts a.name }

p7=Package.new(package_type: PackageType::Paper, name: 'P7').create
p6.add(p7)
# p7.ancestors.values.each { |a| puts a.name }


d2=Delivery.new(name: 'D2').create
p8=Package.new(package_type: PackageType::Paper, name: 'P8').create
p9=Package.new(package_type: PackageType::Paper, name: 'P9').create
p10=Package.new(package_type: PackageType::Paper, name: 'P10').create

p9.add(p10)
d2.add(p9)
d2.add(p8)

p10.add(d1)

p1.ancestors.values.each { |a| puts a.name }
