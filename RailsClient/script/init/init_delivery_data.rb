ActiveRecord::Base.transaction do
  user=User.first
# create deliveries
  1.times do |i|
    did="D#{Time.now.to_milli}#{i}"
    # create forklifts
    forklifts=[]
    3.times do |j|
      fid="F#{Time.now.to_milli}#{j}"
      forklift=Forklift.new(whouse_id: Whouse.first.id, user_id: user.id, id: fid)
      forklift.save
      #create packages
      packages=[]
      2.times do |k|
        Part.all.each do |part|
          pid="WI#{Time.now.to_milli}#{k}"
          PackageService.create({id: pid, part_id: part.id, quantity_str: 'Q110', check_in_time: 'D24.9.9', user_id: user.id}, user).content
          package=Package.find(pid)

          ForkliftService.add_package(forklift, package)
          packages<<package
        end
      end
      forklifts<<forklift
    end
    delivery=Delivery.new(id: did, source_id: Location.first.id, destination_id: Location.first.id, user_id: user.id, delivery_date: Time.now)
    delivery.save
    DeliveryService.add_forklifts(delivery, forklifts.collect { |f| f.id })
  end
end