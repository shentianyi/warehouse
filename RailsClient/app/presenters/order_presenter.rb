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

  def has_out_of_stock
    if self.order_items.where(out_of_stock:true).count > 0
      true
    else
      false
    end
  end

  def to_json
    {
        id: self.id,
        user_id: self.user_id,
        created_at: self.created_at.localtime,
        handled: self.handled ? 1 : 0,
        has_out_of_stock: self.has_out_of_stock ? 1:0
    }
  end

  def to_json_with_order_items
    {
        id: self.id,
        user_id: self.user_id,
        created_at: self.created_at.localtime,
        handled: self.handled ? 1 : 0,
        has_out_of_stock: self.has_out_of_stock ? 1:0,
        order_items: items
    }
  end
end