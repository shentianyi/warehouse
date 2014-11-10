class Container< ActiveRecord::Base
  self.inheritance_column = nil

  include Extensions::UUID
  include Extensions::STATE
  attr_accessor :children, :parent, :ancestors

  belongs_to :user
  belongs_to :location
  belongs_to :part
  has_many :location_containers

  after_initialize :init_container_attr

  def init_container_attr
    self.type=ContainerType.get_type(self.class.name)
  end

end