module LedStateable
  extend ActiveSupport::Concern

  included do
    after_create :create_led_job
  end

  def create_led_job

    puts "344444444343434344334#{self.class.name}"
    args = {}

    case self.class.name
      when "PickList" then
        self.pick_items.each do |pick_item|
          pp = OrderItemService.verify_department(pick_item.order_item.whouse_id, pick_item.order_item.part_id)
          #puts pp.position.detail
          led =  pp.position.led
          args[:led_id] = led.name
          args[:current_state] = led.current_state
          args[:current_display] = led.led_display
          #args[:to_state] = Ptl::Led::PICKED
          args[:server] = led.modem_id
puts args

        end

      when "" then

      when "" then

      else
        puts "00000000000000000000000000"
    end

  end

end