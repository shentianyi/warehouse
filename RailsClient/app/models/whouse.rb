class Whouse < ActiveRecord::Base
  include Extensions::UUID
  include Import::WhouseCsv
  validates_presence_of :name, :message => "名称不能为空!"
  validates_presence_of :nr, :message => "nr不能为空!"
  validates_uniqueness_of :nr, :message => "nr不能重复!"
  belongs_to :location

  has_many :positions, :dependent => :destroy
  has_many :part_positions, :through => :positions
  has_many :parts, :through => :part_positions

  has_many :current_containers, as: :current_positionable, class_name: 'Container'
  has_many :des_containers, as: :destinationable, class_name: 'LocationContainer'
  has_many :source_containers, class_name: 'LocationContainer'
  has_many :storages, as: :storable
  has_many :inventory_lists

  has_one :default_position, -> { where(is_default: true) }, class_name: 'Position'

  after_create :create_default_position

  def self.nr_by_regex(nr)
    nr.sub(/^LO/, '')
  end

  def create_default_position
    self.positions.create(nr: self.nr, is_default: true)
  end
end
