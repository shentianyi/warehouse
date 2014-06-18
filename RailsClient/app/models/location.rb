class Location < ActiveRecord::Base
  include Extensions::UUID

  has_many :users
  has_many :whouses, :dependent => :destroy
end
