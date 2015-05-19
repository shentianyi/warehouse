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
end
