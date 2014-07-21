class Part < ActiveRecord::Base
  include Extensions::UUID
  include Import::PartCsv

  belongs_to :user
  belongs_to :part_type
  has_many :part_positions, :dependent => :destroy
  has_many :positions, :through => :part_positions

  # validate part id existance
  # delete ,no use tesla at 2014-7-21
=begin
  def self.validate_id id
    unless find_by_id(id)
      false
    else
      true
    end
  end
=end
end
