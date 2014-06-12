class Part < ActiveRecord::Base
  include Extensions::UUID

  belongs_to :creator, class_name: "User"

  validates_uniqueness_of :id
end
