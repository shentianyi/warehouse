require 'will_paginate/array'

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

  #after_create :led_state_change#

  #   def led_state_change
  #     puts 'order item created...........'
  #     pp = OrderItemService.verify_department(self.whouse_id,self.part_id)
  #     if pp.nil?
  #       return
  #     end
  #     puts 'position...........'
  #     LedService.update_led_state_by_position(pp.position.detail,LedLightState::ORDERED)
  # =begin
  #     led = Led.find_by_position(position.detail)
  #     to_state = LedLightState::ORDERED
  #     if led.current_state != to_state
  #       led.update({current_state:to_state})
  #     end
  # =end
  #   end

  def generate_id
    "OI#{Time.now.to_milli}"
  end

  def self.generate_report_data(start_t, end_t, source_location_id)
    time_range = Time.parse(start_t)..Time.parse(end_t)
    condition = {}
    condition['order_items.created_at']= time_range
    condition['orders.source_location_id'] = source_location_id

    joins(:order)
        .where(condition)
        .select('order_items.part_id,SUM(order_items.box_quantity) as box_count,SUM(order_items.quantity) as total,order_items.whouse_id as whouse_id,order_items.state,order_items.user_id as user_id')
        .group('part_id,whouse_id,state').order("whouse_id DESC,part_id,state DESC").all
  end

  def self.generate_stockout_data(start_t, end_t, part_id, user)
    condition = {}

    condition["order_items.created_at"] = Time.parse(start_t).utc.to_s...Time.parse(end_t).utc.to_s
    condition["order_items.is_supplement"] = false
    unless part_id.blank?
      condition["order_items.part_id"] = part_id
    end

    records={}
    items=OrderItem.where(condition).select('order_items.part_id as part_id, SUM(order_items.quantity) as qty').group('part_id')
    items.each do |item|
      records[item.part_id]={
          order_count: item.qty,
          send_count: 0,
          stock_count: NStorage.where(partNr: item.part_id, ware_house_id: user.location.whouses.pluck(:id)-[user.location.send_whouse.id, user.location.receive_whouse.id]).size
      }
    end

    # items=OrderItem.where(condition).select('order_items.part_id as part_id, SUM(order_items.quantity) as qty').group('part_id')
    # items.each do |item|
    #   records[item.part_id]={
    #       order_count: item.qty,
    #       send_count: 0
    #   }
    # end

    if part_id
      send_deliveries=LogisticsContainer.joins(:delivery).where(source_location_id: user.location.id, created_at: Time.parse(start_t).utc.to_s...Time.parse(end_t).utc.to_s)
                          .where("containers.part_id=?", part_id)
    else
      send_deliveries=LogisticsContainer.joins(:delivery).where(source_location_id: user.location.id, created_at: Time.parse(start_t).utc.to_s...Time.parse(end_t).utc.to_s)
    end
    send_deliveries.each do |d|
      send_forklifts=LogisticsContainerService.get_forklifts(d)
      send_forklifts.each do |f|
        send_packages=LogisticsContainerService.get_packages(f)
        # part=Part.find_by_id(p.package.part_id)
        send_packages.each do |p|
          if records[p.package.part_id]
            records[p.package.part_id][:send_count]+=1
          else
            records[p.package.part_id]={
                order_count: 0,
                send_count: 1,
                stock_count: NStorage.where(partNr: p.package.part_id, ware_house_id: user.location.whouses.pluck(:id)-[user.location.send_whouse.id, user.location.receive_whouse.id]).size
            }
          end
        end
      end
    end

    records
    # if last_receive=LogisticsContainer.joins(:delivery).where(state: MovableState::CHECKED, des_location_id: user.location.id).order(created_at: :desc).first
    #
    # end
  end

end
