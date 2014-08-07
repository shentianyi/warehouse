class OrderPresenter<Presenter
  Delegators=[:id,:user_id,:created_at,:order_items,:handled]
  def_delegators :@order,*Delegators

  def initialize(order)
    @order = order
    self.delegators = Delegators
  end

  def items
    items = []
    self.order_items.each{|item|
      items << OrderItemPresenter.new(item).to_json
    }
    items
  end

  def to_json
    {
        id: self.id,
        user_id: self.user_id,
        created_at: self.created_at.localtime,
        handled: self.handled ? 1 : 0
    }
  end

  def to_json_with_order_items
    {
        id: self.id,
        user_id: self.user_id,
        created_at: self.created_at.localtime,
        handled: self.handled ? 1 : 0,
        order_items: items
    }
  end
end