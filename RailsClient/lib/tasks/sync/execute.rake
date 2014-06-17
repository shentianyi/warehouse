namespace :sync do
  desc 'pull data from server to sync'
  task :execute => :environment do
    ## base data
    #Sync::Execute::LocationSync.sync
    Sync::Execute::HackerSync.sync
    #Sync::Execute::WhouseSync.sync
    #Sync::Execute::PartSync.sync
    #Sync::Execute::PositionSync.sync
    #Sync::Execute::PartPositionSync.sync
    #
    ## dynamic data
    #Sync::Execute::DeliverySync.sync
    #Sync::Execute::ForkliftSync.sync
    #Sync::Execute::PackageSync.sync
    #Sync::Execute::PackagePositionSync.sync
    #Sync::Execute::StateLogSync.sync
  end
end