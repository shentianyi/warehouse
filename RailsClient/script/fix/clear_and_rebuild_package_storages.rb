puts NStorage.where("packageId like 'WI%'").where(ware_house_id: '3EX').count

puts NStorage.where("packageId like 'WI%'").where(ware_house_id: '3EX').destroy_all
LogisticsContainer.all.each { |l| l.enter_stock }

puts Container.where("id like 'WI%'").count
puts NStorage.where("packageId like 'WI%'").where(ware_house_id: '3EX').count

