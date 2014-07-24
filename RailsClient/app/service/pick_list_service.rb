class PickListService
  def self.covert_order_to_pick_list user_id, order_ids=nil
    order_items=PickItemService.get_order_items(user_id, order_ids)
    if order_items.count>0
      pick_list=PickList.new(user_id: user_id)
      order_items.each do |order_item|
        pick_list.pick_items<<PickItem.new(order_item_id: order_item.id)
      end
      pick_list.save
      return pick_list
    end
  end
end