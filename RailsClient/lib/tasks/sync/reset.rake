namespace :sync do
  desc 'reset is new flag to false'
  task :reset => :environment do
    [User,Location,Whouse,Position,Part,PartPosition].each do |m|
      m.unscoped.update_all(is_new:false,is_dirty:false)
    end
  end
end