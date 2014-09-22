class OrderItemPresenter<Presenter
  Delegators=[:id,:order_id,:location_id,:whouse_id,:user_id,:part_id,:part_type_id,:quantity,:is_emergency,:box_quantity,:is_finished]
  def_delegators :@order_item,*Delegators

  def initialize(order_item)
    @order_item = order_item
    self.delegators = Delegators
  end

  def location
    if self.location_id
      Location.find_by_id(self.location_id).name
    else
      ''
    end
  end

  def whouse
    if self.whouse_id
      Whouse.find_by_id(self.whouse_id).name
    else
      ''
    end
  end

  def source
    if self.part_id && self.whouse_id
      OrderItemService.verify_department(self.whouse_id,self.part_id).sourceable
    else
      nil
    end
  end

  def creator
    if self.user_id
      User.find_by_id(self.user_id).name
    else
      ''
    end
  end

  def part_type
    if self.part_type_id
      PartType.find_by_id(self.part_type_id)
    else
      ''
    end
  end

  def position
    if pp = OrderItemService.verify_department(self.whouse_id,self.part_id)
      pp.position.detail
    else
      ''
    end
  end

  def uniq_id
    self.whouse_id + self.part_id + self.is_emergency.to_s
  end

  def to_json
    {
        id:self.id,
        order_id: self.order_id,
        location_id: self.location,
        whouse_id: self.whouse,
        source_id: self.source ? self.source.id : '',
        source: self.source ? self.source.name : '',
        user_id: self.creator,
        part_id: OrderItemLabelRegex.part_prefix_string + self.part_id,
        part_type_id: self.part_type,
        is_emergency: self.is_emergency ? 1:0,
        quantity: OrderItemLabelRegex.quantity_prefix_string + self.quantity.to_s,
        position: self.position,
        uniq_id: self.uniq_id,
        box_quantity: self.box_quantity
        is_finished: slef.is_finished
    }
  end
end