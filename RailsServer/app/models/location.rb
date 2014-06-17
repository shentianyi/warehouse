class Location < ActiveRecord::Base
  include Extensions::UUID

  has_many :users
end
