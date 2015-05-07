location_offset = rand(Location.count)
part = Part.first
location = Location.find_by_id('l001')#Location.first(:offset => location_offset)
warehouse_offset = rand(location.whouses.count)
10.times {
  whouse = location.whouses.order("RAND()").first
  Storage.create({location_id:location.id,part_id:part.id,quantity:rand(500),storable_id:whouse.id,storable_type:whouse.class.to_s})
}