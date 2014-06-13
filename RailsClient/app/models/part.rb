class Part < ActiveRecord::Base
  include Extensions::UUID

  belongs_to :user

  validates_uniqueness_of :id

  # validate part id existance
  def self.validate_part_id

  end
end
