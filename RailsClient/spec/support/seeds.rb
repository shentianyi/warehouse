RSpec.configure do |config|
  config.before(:suite) do
     load Rails.root.join("db/seeds.rb")
     PackageLabelRegex.initialize_methods if ActiveRecord::Base.connection.table_exists?('regexes')
     SysConfigCache.initialize_methods if ActiveRecord::Base.connection.table_exists?('sys_configs')
  end
end