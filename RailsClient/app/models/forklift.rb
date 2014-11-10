class Forklift<Container
  default_scope { where(type: ContainerType::Forklift) }

  alias_method :stocker, :user
end