class Whouse < ActiveRecord::Base
  include Extensions::UUID
  include Import::WhouseCsv

  belongs_to :location
  has_many :positions, :dependent => :destroy
  has_many :part_positions, :through => :positions
  has_many :parts, :through => :part_positions
  has_many :current_containers, as: :current_positionable, class_name: 'LocationContainer'
  has_many :source_containers, as: :sourceable, class_name: 'LocationContainer'
  has_many :destination_containers, as: :desitinationalbe, class_name: 'LocationContainer'

end
