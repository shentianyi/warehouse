namespace :sync do
  desc 'reset is new flag to false'
  task :reset => :environment do
    [User,Location,Whouse,Position,Delivery,Forklift,Package,PackagePosition,Part,PartPosition,StateLog].each do |m|
      m.unscoped.update_all(is_new:true)
    end
  end
end