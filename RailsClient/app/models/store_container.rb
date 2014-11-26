class StoreContainer<LocationContainer
  default_scope { where(type: LocationContainerType::STORE) }
  has_ancestry
  belongs_to :package, foreign_key: :container_id

  before_create :init_container_state

  def init_container_state
    self.state=StorableState::INIT
  end

  def in_store(storable)
    p=self.package
    part=p.part
    p.current_positionable=storable
    self.state=StorableState::INSTORE
    unless s=part.storages.where(storable: storable).first
      s=part.storages.build(quantity: p.quantity)
      s.storable=storable
    else
      s.quantity+=p.quantity
    end
    s.save
    p.save
  end

  def move_store

  end

  def cancel_store
    p=self.package
    part=p.part
    if s=part.storages.where(storable: p.current_positionable).first
      s.quantity=0
      s.save
    end
    p.current_positionable=nil
    p.save
  end
end
