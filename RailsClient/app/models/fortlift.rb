class Fortlift < ActiveRecord::Base
  include Extensions::UUID
  include Extensions::STATE

  belongs_to :delivery
  has_many :state_logs, as: :stateable
  has_many :fortlift_itmes, :dependent => :destroy
  has_many :packages, :through => :fortlift_items
end
