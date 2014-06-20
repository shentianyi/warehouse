class Position < ActiveRecord::Base
  include Extensions::UUID
  include Import::PositionCsv

  belongs_to :whouse
  has_many :part_positions, :dependent => :destroy
end
