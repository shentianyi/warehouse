module LedStateable
  extend ActiveSupport::Concern

  included do
    after_create :create_led_job
  end

  def create_led_job

    puts "344444444343434344334#{self.class.name}"

    case self.class.name
      when "PickList" then
        self.pick_items.each do |pick_item|
          pp = OrderItemService.verify_department(pick_item.order_item.whouse_id, pick_item.order_item.part_id)
          puts pp.position.detail
          puts pp.position.led

        end

      when "" then

      when "" then

      else
        puts "00000000000000000000000000"
    end

  end

end