class Delivery < ActiveRecord::Base
  include Extensions::UUID

  belongs_to :users
  has_many :state_logs, as: :stateable
end
