class StoreContainer<LocationContainer
  default_scope { where(type: LocationContainerType::STORE) }
  has_ancestry
  belongs_to :package, foreign_key: :container_id

  before_create :init_container_state

  def init_container_state
    self.state=StorableState::INIT
  end

  def in_store(storable)
    if self.can_in_store?
      c=self.container
      c.current_positionable=storable
      self.state=StorableState::INSTORE
      c.save
      self.save

      if part=c.part
        unless s=part.storages.where(storable: storable).first
          s=part.storages.build(quantity: c.quantity)
          s.storable=storable
        else
          s.quantity+=c.quantity
        end
        s.save
      end
    end
  end

  def move_store(destination)
    if self.can_move_store?
      c=self.container
      if part=c.part
        if ss=part.storages.where(storable: p.current_positionable).first
          ss.quantity-=c.quantity
          ss.save
        end
        if ds=part.storages.where(storable: destination).first
          ds.quantity+=c.quantity
        else
          ds=part.storages.build(quantity: c.quantity)
          ds.storable=destination
        end
        ds.save
      end
      c.current_positionable=destination
      c.save
    end
  end

  def cancel_store
    if self.can_cancel_store?
      c=self.container
      if  c=p.part
        if s=part.storages.where(storable: p.current_positionable).first
          s.quantity=0
          s.save
        end
      end
      c.current_positionable=nil
      c.save
    end
  end

  def can_in_store?
    self.state==StorableState::INIT
  end

  def can_cancel_store?
    self.state==StorableState::INIT
  end

  def can_move_store?
    self.state==StorableState::INSTORE
  end
end
