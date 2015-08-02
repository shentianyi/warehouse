namespace :ptl do
  desc 'start ptl server....'
  task :server => :environment do
    Ptl::Server.run
  end
end