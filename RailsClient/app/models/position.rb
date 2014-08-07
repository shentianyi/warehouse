class Position < ActiveRecord::Base
  include Extensions::UUID
  include Import::PositionCsv

  belongs_to :whouse
  has_many :part_positions, :dependent => :destroy
  has_many :parts, :through => :part_positions


  def generate_id
    "PS#{Time.now.to_milli}"
  end
end
