class OrderItem < ActiveRecord::Base
	include Extensions::UUID

	belongs_to :order
	belongs_to :user
	belongs_to :location
	belongs_to :whouse
	#belongs_to :source, class_name: "Location"
	belongs_to :part
	belongs_to :part_type
  has_many :pick_items

  after_create :led_state_change

  def led_state_change
    puts 'order item created...........'
    pp = OrderItemService.verify_department(self.whouse_id,self.part_id)
    if pp.nil?
      return
    end
    puts 'position...........'
    LedService.update_led_state_by_position(pp.position.id,LedLightState::ORDERED)
=begin
    led = Led.find_by_position(position.detail)
    to_state = LedLightState::ORDERED
    if led.current_state != to_state
      led.update({current_state:to_state})
    end
=end
  end

  def generate_id
    "OI#{Time.now.to_milli}"
  end

  def self.generate_report_data(start_t,end_t,source_location_id)
    time_range = Time.parse(start_t)..Time.parse(end_t)
    condition = {}
    condition['order_items.created_at']= time_range
    condition['orders.source_location_id'] = source_location_id

    joins(:order)
        .where(condition)
        .select('order_items.part_id,SUM(order_items.box_quantity) as box_count,SUM(order_items.quantity) as total,order_items.whouse_id as whouse_id,order_items.state,order_items.user_id as user_id')
        .group('part_id,whouse_id,state').order("whouse_id DESC,part_id,state DESC").all
  end
end
