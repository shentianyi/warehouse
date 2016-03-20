class Forklift<Container
  default_scope { where(type: ContainerType::FORKLIFT) }

  def generate_id
    "F#{Time.now.strftime('%Y%m%d%H%M%S')}"
  end

end