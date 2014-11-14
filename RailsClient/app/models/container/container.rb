class Container< ActiveRecord::Base
  self.inheritance_column = nil

  include Extensions::UUID
  include Extensions::STATE
  attr_accessor :children, :parent, :ancestors

  belongs_to :user
  belongs_to :location
  belongs_to :part
  has_many :location_containers, :dependent => :destroy

  after_initialize :init_container_attr

  def init_container_attr
    self.type=ContainerType.get_type(self.class.name)
  end

  def self.exists?(id)
    self.find_by_id(id)
  end

  def destroy_dependent(id)
    LocationContainer.destroy_by_container_id(id)
  end
end