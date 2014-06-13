class Delivery < ActiveRecord::Base
  include Extensions::UUID
  include Extensions::STATE

  belongs_to :users
  has_many :state_logs, as: :stateable
  belongs_to :user
  belongs_to :source, class_name: "Location"
  belongs_to :destination, class_name: "Location"
end
