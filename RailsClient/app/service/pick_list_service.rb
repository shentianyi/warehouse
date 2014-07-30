class PickListService
  def self.covert_order_to_pick_list user_id, order_ids
    order_items=PickItemService.get_order_items(user_id, order_ids)
    if order_items.count>0
      pick_list=PickList.new(user_id: user_id)
      puts pick_list.to_json
      order_items.each do |i|
        pick_list.pick_items<<PickItem.new(
            quantity: i.quantity,
            box_quantity: i.box_quantity,
            destination_whouse_id: i.whouse_id,
            user_id: i.user_id,
            part_id: i.part_id,
            part_type_id: i.part_type_id,
            remark: i.remark,
            is_emergency: i.is_emergency
        )
      end
      pick_list.save
      return pick_list
    end
  end
end