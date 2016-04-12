class Location < ActiveRecord::Base
  include Extensions::UUID
  include Import::LocationCsv
  validates_uniqueness_of :nr, message: '不可重复'
  validates_presence_of :name, :message => "名称不能为空!"

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

  belongs_to :receive_whouse, class_name: 'Whouse'
  belongs_to :send_whouse, class_name: 'Whouse'
  belongs_to :order_source_location, class_name: 'Location', foreign_key: :order_source_location_id

  belongs_to :default_whouse,class_name: 'Whouse',foreign_key: :default_whouse_id

  def whouse_ids
    ids= self.whouses.pluck(:id)
    if self.send_whouse
      ids= ids-[self.send_whouse.id]
    end
    if self.receive_whouse
      ids= ids-[self.receive_whouse.id]
    end
    ids
  end

  def default_destination
    @default_destination||=(self.default_location_destination.present? ? self.default_location_destination.destination : nil)
  end

  def add_destination(location)
    if self.location_destinations.count == 0
      self.location_destinations.create({destination_id: location.id, is_default: true})
    else
      self.location_destinations.create({destination_id: location.id})
    end
  end

  def set_default_destination(location)
    self.location_destinations.update_all(is_default: false)
    self.location_destinations.where(destination_id: location.id).update_attributes(is_default: true)
  end
end