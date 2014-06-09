class Delivery < ActiveRecord::Base
  include Extensions::UUID

  belongs_to :users
end
