namespace :sync do
  desc 'move stock after MRP backflush'
  task :move_stock => :environment do
    puts 'start move stock'
    Mrp::MoveStock.move_stock
  end
end