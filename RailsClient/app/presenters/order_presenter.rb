class OrderPresenter<Presenter
  Delegators=[:id,:user_id,:created_at,:order_items,:handled,:remark]
  def_delegators :@order,*Delegators

  def initialize(order)
    @order = order
    self.delegators = Delegators
  end

  def items(user=nil)
    items = []
    self.order_items.each{|item|
      items << OrderItemPresenter.new(item).to_json(user)
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
        remark: self.remark,
        handled: self.handled ? 1 : 0,
        has_out_of_stock: self.has_out_of_stock ? 1:0
    }
  end

  def to_json_with_order_items(user=nil)
    {
        id: self.id,
        user_id: self.user_id,
        created_at: self.created_at.localtime,
        handled: self.handled ? 1 : 0,
        remark: self.remark,
        has_out_of_stock: self.has_out_of_stock ? 1:0,
        order_items: items(user)
    }
  end
end