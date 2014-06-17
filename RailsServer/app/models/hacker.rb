class Hacker < ActiveRecord::Base
  self.table_name = 'users'
  validates_uniqueness_of :id
end
