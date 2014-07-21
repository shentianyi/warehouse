class OrderPresenter<Presenter
  Delegators=[:id,:user_id]
  def_delegators :@order,*Delegators

  def initialize(order)
    @order = order
    self.delegators = Delegators
  end

  def to_json
    {
        id: self.id,
        user_id: self.user_id,
        created_at: self.created_at
    }
  end

  def to_json_with_order_items
    {
        id: self.id,
        user_id: self.user_id,
        created_at: self.created_at
    }
  end
end