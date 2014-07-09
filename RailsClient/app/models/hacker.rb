class Hacker < ActiveRecord::Base
  self.table_name = 'users'
  include Extensions::UUID
end
