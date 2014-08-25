class LedService

  def self.send_msg(led_id, msg, modem_ip)
    return ModemRest::Msg.new(led_id:led_id, msg: msg, ip: modem_ip).change_led_state
  end

  #def self.send_msg_by_led_state(led_state, position_detail)
  #  # get state msg
  #  #msg= LedState.get_state_msg(led_state)
  #  msg= led_state
  #
  #  process_msg=Message.new
  #  if (led=Led.find_by_position(position_detail)) && (modem=led.modem)
  #    process_msg= self.send_msg(led.signal_id, msg, modem.ip)
  #  else
  #    process_msg.content ='LED不存在 或 LED未设置解调器'
  #  end
  #  return process_msg
  #end

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
    puts '-----------------------m-sg------'
    puts msg.to_json
    return msg
  end
end
