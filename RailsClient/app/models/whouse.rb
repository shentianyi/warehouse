class Whouse < ActiveRecord::Base
  include Extensions::UUID


  belongs_to :location
  
  has_many :positions, :dependent => :destroy
  has_many :part_positions, :through => :positions
  has_many :parts, :through => :part_positions

  has_many :current_containers, as: :current_positionable, class_name: 'Container'
  has_many :des_containers, as: :destinationable, class_name: 'LocationContainer'
  has_many :source_containers, class_name: 'LocationContainer'
  has_many :storages, as: :storable
  has_many :inventory_lists

  include Import::WhouseCsv

  def self.nr_by_regex(nr)
    nr.sub(/^LO/,'')
  end
end
