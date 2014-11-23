#LocationContainer.destroy_all

#transfer all old packages,forklifts,deliveries to containers.
#than build location_containers
#than add records

# *Delivery,*Forklift的所有状态都转化为到达，
# *Package中所有的状态，如果是Destination的并且Forklift也是Destination的，则修改为拒收，Rejected
# *同时，需要产生多少条Record，需要留意创建。
# *注意那些空的Package,Forklift,Delivery
class OPackage < ActiveRecord::Base
  include Extensions::UUID
  self.table_name = "packages"
end

class OForklift < ActiveRecord::Base
  include Extensions::UUID
  self.table_name = "forklifts"

  has_many :packages, class_name: "OPackage", foreign_key: 'forklift_id'
end

class ODelivery < ActiveRecord::Base
  include Extensions::UUID
  self.table_name = "deliveries"

  has_many :forklifts, class_name: "OForklift", foreign_key: 'delivery_id'
end

#*先创建Delivery
ODelivery.all.each do |od|
  #create Delivery Container
  #create Delivery Location_Container =>
  #
end

#transfer Old deliveries
=begin
ODelivery.all.each do |od|
  #create delivery container
  d = Delivery.create({id:od.id,state:od.state,location_id:od.location_id,user_id:od.user_id,current_position_id:od.destination_id, current_position_type:"Location"})
  #create delivery location_container
  lc = d.logistics_containers.build(source_location_id: d.location_id, user_id: d.user_id)


  #create forklift containers of delivery
  #create forklift location_container

  #add forklifts location_containers to delivery container

  #create package containers
  #create package location_containers

  #add package location_containers to forklift location_containers

  #create action record for all location_containers
end
=end

=begin
Package.all.each do |p|
  lc=p.location_containers.build
  lc.location=p.user.location if p.user
  lc.save
end
=end
