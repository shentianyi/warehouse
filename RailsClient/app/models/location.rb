class Location < ActiveRecord::Base
  include Extensions::UUID
  include Import::LocationCsv

  has_many :users
  has_many :whouses, :dependent => :destroy
  has_many :location_destinations
  has_many :destinations, :through => :location_destinations
  belongs_to :destination, class_name: 'Location'

  has_many :current_containers, as: :current_positionable, class_name: 'Container'
  has_many :des_containers, class_name: 'LocationContainer'
  has_many :source_containers, class_name: 'LocationContainer'
  belongs_to :parent, class_name: 'Location'

  def self.default_destination
    if d = Location.where(location_type: LocationType::DESTINATION).first
      d
    else
      Location.where(location_type: LocationType::BASE).first
    end
  end

  def self.list
    self.all.select { |l| l unless l.is_base }
  end

  def self.list_menu current_user=nil
    #if current_user.employee?
    #  [[current_user.location.name,current_user.location.id]]
    #else
    self.list.collect { |l| [l.name, l.id] }
    #end
  end
end
