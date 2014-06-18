class Part < ActiveRecord::Base
  include Extensions::UUID

  belongs_to :user
  has_many :part_positions, :dependent => :destroy

  validates_uniqueness_of :id

  # validate part id existance
  def self.validate_id id
    unless find_by_id(id)
      false
    else
      true
    end
  end
end
