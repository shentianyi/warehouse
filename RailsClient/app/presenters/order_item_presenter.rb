class OrderItemPresenter<Presenter
  Delegators=[:id,:order_id,:location_id,:whouse_id,:source_id,:user_id,:part_id,:part_type_id,:quantity]
  def_delegators :@order_item,*Delegators

  def initialize(order_item)
    @order_item = order_item
    self.delegators = Delegators
  end

  def to_json
    {
        id:self.id,
        order_id: self.order_id,
        location_id: self.location_id,
        whouse_id: self.whouse_id,
        source_id: self.source_id.nil? ? '':self.source_id,
        user_id: self.user_id,
        part_id: self.part_id,
        part_type_id: self.part_type_id,
        quantity: self.quantity
    }
  end
end