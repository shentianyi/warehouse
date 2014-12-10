

#LocationContainer.destroy_all

#transfer all old packages,forklifts,deliveries to containers.
#than build location_containers
#than add records

# *Delivery,*Forklift的所有状态都转化为到达，
# *Package中所有的状态，如果是Destination的并且Forklift也是Destination的，则修改为拒收，Rejected
# *同时，需要产生多少条Record，需要留意创建。
# *注意那些空的Package,Forklift,Delivery

#*先创建Delivery
all_old_deliveries = Old::ODelivery.all.order(created_at: :desc).limit(500)

piece = 5

count = 0
all_old_deliveries.each_slice(piece).to_a.each do |old_deliveries|
  count+=1
  puts "#{count}个Worker已被建立!"
  ids = old_deliveries.collect { |od| od.id }
  TransContainerWorker.perform_async(ids)
end

#TransContainerWorker.perform_async(all_old_deliveries.first.id)
