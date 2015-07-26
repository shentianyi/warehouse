class Delivery < Container
  include LedStateable
  default_scope { where(type: ContainerType::DELIVERY) }

  def generate_id
    "D#{Time.now.to_milli}"
  end
end
