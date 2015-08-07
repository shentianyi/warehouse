module LedStateable
  extend ActiveSupport::Concern

  included do
    after_create :create_led_job
    after_update :update_led_job
  end

  def create_led_job

    return unless (SysConfigCache.led_enable_value=='true')

    puts "create ###############################{self.class.name}"
    args = {}

    case self.class.name
      when "PickList" then
        self.pick_items.each do |pick_item|
          pp = OrderItemService.verify_department(pick_item.order_item.whouse_id, pick_item.order_item.part_id)
          #puts pp.position.detail
          led =  pp.position.led
          args[:led_id] = led.id
          args[:current_state] = led.current_state
          args[:current_display] = led.led_display
          args[:to_state] = Ptl::Node::PICKED
         # args[:server] = led.modem_id
        #  args[:server_url] = Modem.find(led.modem_id).ip

          #function(args) #job action
          Ptl::Job.new(
              node_id: args[:led_id],
              curr_state: args[:current_state],
              to_state: args[:to_state],
              curr_display: args[:current_display],
              size: 1,
              in_time: true
          ).in_queue
        end
      else
        puts "create #######################################"
    end

  end

  def update_led_job

    return unless (SysConfigCache.led_enable_value=='true')

    puts "update ###############################{self.class.name}"
    args = {}

    case self.class.name
      when "LogisticsContainer" then
        return unless self.state_changed?
        puts self.state_was
        puts self.state
        return unless self.container_id.include?('WI')

        whouse = self.destinationable_id
        part_id = Container.find(self.container_id).part_id
        pp = Part.get_default_position(whouse, part_id)
if pp.nil?
  return
end
        led =  pp.position.led
        if led.nil?
          puts "this position have no led!"
          return
        end

        args[:led_id] = led.id
        args[:current_state] = led.current_state

        if self.state == BaseState::WAY
          args[:to_state] = Ptl::Node::DELIVERED

        elsif self.state == BaseState::DESTINATION

          return
        elsif self.state == BaseState::RECEIVED
          args[:to_state] = Ptl::Node::RECEIVED

        else
          args[:to_state] = nil
        end
        args[:current_display] = led.led_display
      #  args[:server] = led.modem_id
      #  args[:server_url] = Modem.find(led.modem_id).ip
        puts args

        #function(args) #job action
        Ptl::Job.new(
            node_id: args[:led_id],
            curr_state: args[:current_state],
            to_state: args[:to_state],
            curr_display: args[:current_display],
            size: 1,
            in_time: true
        ).in_queue
      else
        puts "update ##############################"
    end

  end

end