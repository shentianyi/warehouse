class Forklift<Container
  default_scope { where(type: ContainerType::FORKLIFT) }

  def generate_id
    "F#{Time.now.to_milli}"
  end
end