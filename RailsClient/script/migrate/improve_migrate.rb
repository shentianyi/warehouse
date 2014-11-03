LocationContainer.destroy_all

Package.all.each do |p|
  lc=p.location_containers.build
  lc.location=p.user.location if p.user
  lc.save
end