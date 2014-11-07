class Container< ActiveRecord::Base
  self.inheritance_column = nil
  validates_uniqueness_of :custom_id

  include Extensions::UUID
  include Extensions::STATE
  attr_accessor :children, :parent, :ancestors

  belongs_to :user
  belongs_to :location
  belongs_to :part
  has_many :location_containers

  after_initialize :init_container_type

  def init_container_type
    self.type=ContainerType.get_type(self.class.name)
  end

  def generate_uuid
    self.custom_id = self.send(:generate_id) if self.custom_id.nil? && self.respond_to?(:generate_id)
    self.id = SecureRandom.uuid
  end
end