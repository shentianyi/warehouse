class Whouse < ActiveRecord::Base
  include Extensions::UUID
  include Import::WhouseCsv

  belongs_to :location
  has_many :positions, :dependent => :destroy
  has_many :part_positions, :through => :positions
  has_many :parts, :through => :part_positions
end
