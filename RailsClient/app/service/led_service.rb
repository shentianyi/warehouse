class LedService

  def self.send_msg(led_id, msg, modem_ip)
    if SysConfigCache.led_enable_value=='true'
      return ModemRest::Msg.new(led_id: led_id, msg: msg, ip: modem_ip).change_led_state
    end
  end

  def self.update_led_state_by_position(position_detail, led_state)
    return update_led_state(Led.find_by_position(position_detail), led_state)
  end

  def self.update_led_state_by_id(id, led_state)
    return update_led_state(Led.find_by_id(id), led_state)
  end

  def self.update_led_state(led, led_state)
    msg=Message.new
    if led
      led.update(current_state: led_state)
      msg.result =true
      msg.content ='LED 状态已改变'
    else
      msg.content = 'LED 不存在'
    end
    puts '-----------------------msg------'
    puts msg.to_json
    return msg
  end

  def self.create_stockout_list(led_id, is_emergency, box_quantity=1)

    position = Position.find_by_detail(Led.find_by_name(led_id).position)
    source_id = LocationDestination.where(destination_id: position.whouse)
    part = position.default_part
    builder = User.find(SysConfigCache.led_builder_value)
    quantity = part.unit_pack * box_quantity

    item = {part_id: part.id, quantity: quantity, box_quantity: box_quantity, department: position.whouse}
    args = {part_id: part.id, quantity: quantity, box_quantity: box_quantity, department: position.whouse, is_emergency: is_emergency}
    OrderService.create_with_items({order: source_id, order_items: item, nopart_items: args}, builder)

    # order = Order.new()
    # builder = User.find(SysConfigCache.led_builder_value)
    # order.user = builder
    # puts order.user
    #
    # order.source_location_id = builder.location_id
    # ActiveRecord::Base.transaction do
    #   begin
    #     if order.save
    #       #save success
    #       part = OrderItemService.verify_part_id(part.id, builder)
    #       part_position = OrderItemService.verify_department(position.detail, part.id)
    #       #quantity = item[:quantity]
    #       box_quantity = count
    #
    #       if item = OrderItemService.new(part_position, part, 1, true, box_quantity, builder)
    #         item.order = order
    #         item.save
    #       end
    #     else
    #       return nil
    #     end
    #
    #   rescue ActiveRecord::RecordInvalid => invalid
    #     return nil
    #   end
    # end

  end

end
