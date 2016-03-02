class Location < ActiveRecord::Base
  include Extensions::UUID
  include Import::LocationCsv
  validates_uniqueness_of :nr, message: '不可重复'
  belongs_to :tenant
  has_many :users
  has_many :whouses, :dependent => :destroy
  has_many :location_destinations, :dependent => :destroy
  has_one :default_location_destination, -> { where(is_default: true) }, class_name: 'LocationDestination', :dependent => :destroy


  has_many :destinations, :through => :location_destinations
  belongs_to :destination, class_name: 'Location'

  has_many :current_containers, as: :current_positionable, class_name: 'Container'
  has_many :des_containers, class_name: 'LocationContainer'
  has_many :source_containers, class_name: 'LocationContainer'
  belongs_to :parent, class_name: 'Location'

  #has_one :default_destination, -> { where(location_destinations:{is_default: true}) }, class_name: 'Location', through: :location_destinations,source: :location_destinations

  # before_update :reset_foreign_key

  # def reset_foreign_key
  #   if self.id_changed?
  #     self.users.update_all(location_id: self.id)
  #     # raise
  #   end
  # end

  def default_destination
    @default_destination||=(self.default_location_destination.present? ? self.default_location_destination.destination : nil)
  end
end