class Forklift<Container
  default_scope { where(type: ContainerType::Forklift) }

  def generate_id
    "F#{Time.now.to_milli}"
  end
end