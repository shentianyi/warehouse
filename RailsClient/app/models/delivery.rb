class Delivery < Container
  default_scope { where(type: ContainerType::DELIVERY) }
  has_many :delivery_pick_lists,dependent: :destroy
  has_many :pick_lists,through: :delivery_pick_lists
  def generate_id
    "D#{Time.now.strftime('%y%m%d%H%M%S')}"
  end

end
