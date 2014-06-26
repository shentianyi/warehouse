namespace :sync do
  desc 'pull data from server to sync'
  task :execute => :environment do
    ## base data
    current=Time.now
    Sync::Execute::LocationSync.sync
    Sync::Execute::UserSync.sync
    Sync::Execute::WhouseSync.sync
    Sync::Execute::PartSync.sync
    Sync::Execute::PositionSync.sync
    Sync::Execute::PartPositionSync.sync

    # dynamic data
    Sync::Execute::DeliverySync.sync
    Sync::Execute::ForkliftSync.sync
    Sync::Execute::PackageSync.sync
    Sync::Execute::PackagePositionSync.sync
    Sync::Execute::StateLogSync.sync


    Sync::Config.last_time=(current- Sync::Config.advance_second.seconds)
  end
end