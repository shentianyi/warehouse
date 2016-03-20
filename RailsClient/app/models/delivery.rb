class Delivery < Container
  default_scope { where(type: ContainerType::DELIVERY) }

  def generate_id
    "D#{Time.now.strftime('%y%m%d%H%M%S')}"
  end

end
