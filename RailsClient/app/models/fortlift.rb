class Fortlift < ActiveRecord::Base
  include Extensions::UUID
  include Extensions::STATE

  belongs_to :delivery
  has_many :state_logs, as: :stateable
end
