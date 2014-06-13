class ForkliftItem < ActiveRecord::Base
  include Extensions::UUID
  include Extensions::STATE

  belongs_to :package
  belongs_to :forklift
  belongs_to :user
end
