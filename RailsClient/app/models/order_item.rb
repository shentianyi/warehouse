class OrderItem < ActiveRecord::Base
	include Extensions::UUID

	belongs_to :order
	belongs_to :user
	belongs_to :location
	belongs_to :whouse
	#belongs_to :source, class_name: "Location"
	belongs_to :part
	belongs_to :part_type

  after_create led_state_change

  def led_state_change
    position = OrderItemService.verify_department(self.whouse.name,self.part_id)
    if position.nil?
      return
    end
    led = Led.find_by_position(position.detail)
    to_state = LedLightState::ORDERED
    if led.current_state != to_state
      led.update({current_state:to_state})
    end
  end

  def generate_id
    "OI#{Time.now.to_milli}"
  end
end
