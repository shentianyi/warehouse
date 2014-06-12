class Delivery < ActiveRecord::Base
  include Extensions::UUID
  include Extensions::STATE

  belongs_to :users
  has_many :state_logs, as: :stateable
end
