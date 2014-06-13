class ForkliftItem < ActiveRecord::Base
  include Extensions::UUID
  include Extensions::STATE

  has_many :state_logs, as: :stateable
  belongs_to :package
  belongs_to :forklift
  belongs_to :user
end
