class Part < ActiveRecord::Base
  include Extensions::UUID

  validates_uniqueness_of :partnum
end
