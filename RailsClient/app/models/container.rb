class Container< ActiveRecord::Base
  self.inheritance_column = nil

  include Extensions::UUID

  belongs_to :user
  belongs_to :location
  belongs_to :part
  belongs_to :current_positionable, polymorphic: true
  has_many :logistics_containers, :dependent => :destroy
  has_many :store_containers, :dependent => :destroy

  before_create :init_container_attr
  # before_save :convert_time
  #
  # def convert_time
  #   self.fifo_time=self.fifo_time - 8.hour
  # end

  def init_container_attr
    self.type=ContainerType.get_type(self.class.name)
  end

  def self.exists?(id)
    self.find_by_id(id)
  end

  def destroy_dependent(id)
    LocationContainer.destroy_by_container_id(id)
  end


  def is_package?
    self.type==ContainerType::PACKAGE
  end

end