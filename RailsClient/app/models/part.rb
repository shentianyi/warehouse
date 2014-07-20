class Part < ActiveRecord::Base
  include Extensions::UUID
  include Import::PartCsv
  belongs_to :user
  belongs_to :part_type
  has_many :part_positions, :dependent => :destroy


  # validate part id existance
  def self.validate_id id
    unless find_by_id(id)
      false
    else
      true
    end
  end
end
