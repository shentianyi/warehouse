class LocationContainer < ActiveRecord::Base
  self.inheritance_column = nil
  include Extensions::UUID
  include CZ::State
  # has_ancestry
  belongs_to :user
  belongs_to :container
  belongs_to :current_positionable, polymorphic: true


  belongs_to :destinationable, polymorphic: true
  belongs_to :source_location, class_name: 'Location'
  belongs_to :des_location, class_name: 'Location'

  has_many :location_container_pick_lists, dependent: :destroy
  has_many :pick_lists,through: :location_container_pick_lists

  # has_ancestry
  # acts_as_tree
  before_create :init_container_attr

  def init_container_attr
    self.type=LocationContainerType.get_type(self.class.name.sub(/Container/, ''))
  end

  def self.exists?(id)
    self.find_by_id(id)
  end

  def self.destroy_by_container_id(container_id)
    where(container_id: container_id).update_all(is_delete: true, is_dirty: true, ancestry: nil)
  end


end