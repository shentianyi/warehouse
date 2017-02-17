#encoding: utf-8
class PickItemPresenter<Presenter
  Delegators=[:id, :status]
  def_delegators :@pick_item, *Delegators

  def initialize(pick_item)
    @pick_item=pick_item
    self.delegators =Delegators
  end


  def as_basic_info
    {
        id: @pick_item.id,
        status: @pick_item.status
    }
  end

  def orderable
    if (order_item=@pick_item.order_item) && (orderable=order_item.orderable)
      orderable
    else
      nil
    end
  end

  def as_detail
    o=self.orderable

    {
        id: @pick_item.id,
        status: @pick_item.state,
        quantity: @pick_item.quantity,
        box_quantity: @pick_item.box_quantity,
        order_box: o.nil? ? nil : OrderBoxPresenter.new(o).as_basic_info(true),
        part: PartPresenter.new(@pick_item.part).as_basic_info,
        weight: @pick_item.weight.blank? ? 0 : @pick_item.weight,
        weight_qty: @pick_item.weight_qty.blank? ? 0 : @pick_item.weight_qty,
        weight_valid: @pick_item.weight_valid.blank? ? 0 : @pick_item.weight_valid
    }
  end

  def self.as_details(pick_items)
    json=[]
    pick_items.each do |pick_item|
      json<<PickItemPresenter.new(pick_item).as_detail()
    end
    json
  end

  def self.as_pick_infos(pick_items, user)
    json=[]
    pick_items.each do |pick_item|
      json<<{
          pick_item_id: pick_item.id,
          packageIds: PickItemPresenter.new(pick_item).pick_info(user)
      }
    end
    json
  end

  def pick_info pick_user
    @pick_item.pick_info pick_user
  end

end