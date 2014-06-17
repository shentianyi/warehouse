namespace :sync do
  desc 'pull data from server to sync'
  task :execute => :environment do
    Sync::Execute::UserSync.sync
  end
end