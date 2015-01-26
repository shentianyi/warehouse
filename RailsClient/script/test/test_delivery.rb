sender = User.where({role_id:Role.sender}).first

package_id = "WI#{Time.now.to_milli}"

package = PackageService.create({id:package_id,part_id:Part.first,check_in_time:"12 15 13"},sender).object

forklift = ForkliftService.create({destinationable_id:Whouse.first.id},sender).object

forklift.add(package)

delivery = DeliveryService.create({},sender).object

delivery.add(forklift)