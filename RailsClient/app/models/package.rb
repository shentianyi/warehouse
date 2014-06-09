class Package < ActiveRecord::Base
  include Extensions::UUID

  belongs_to :fortlift
  has_many :state_logs, as: :stateable
end
