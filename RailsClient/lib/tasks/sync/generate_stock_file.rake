namespace :sync do
  desc 'generate new stock file for MRP sync'
  task :generate_stock_file => :environment do
    #generate file
    puts 'start ...'
    Mrp::StockSync.send_file
  end
end