class StoreContainer<LocationContainer
  default_scope { where(type: LocationContainerType::STORE) }
  has_ancestry
end