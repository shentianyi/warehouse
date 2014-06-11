class Role < ActiveRecord::Base
	include Extensions::UUID
	has_and_belongs_to_many :users
end
