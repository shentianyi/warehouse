class Forklift < ActiveRecord::Base
  include Extensions::UUID
  include Extensions::STATE

  belongs_to :delivery
  has_many :state_logs, as: :stateable
  has_many :forklift_itmes, :dependent => :destroy
  has_many :packages, :through => :forklift_items
  belongs_to :creator, class_name: "User"
  belongs_to :stocker, class_name: "User"
end
