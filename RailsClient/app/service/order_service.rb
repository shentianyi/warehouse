class OrderService

  #=============
  #
  #=============
  def self.where condition
    Order.where(condition)
  end

  #=============
  #get last n days order
  #params
  # @user_id:current_user.id,
  # @current_user: get location id
  # @days: integer
  # @state: false
  #=============
  def self.get_orders_by_days location_ids, days=7, handled = false, user_id = nil
    start_time = days.days.ago.at_beginning_of_day.utc
    end_time = Time.now.at_end_of_day.utc
    if user_id.nil?
      find({created_at: (start_time..end_time), handled: handled, source_location_id: location_ids})
    else
      find({created_at: (start_time..end_time), user_id: user_id, handled: handled, source_id: location_ids})
    end
  end

  #-------------
  #orders_by_fiters. get orders by filters
  #params
  # @user_id
  # @order_ids
  # @filters
  #-------------
  def self.orders_by_filters user_id, orders, filters = nil
    user = User.find_by_id user_id
    if user.nil?
      return []
    end
    order_items = PickItemService.get_order_items(user_id, get_orders_by_days(user.location_destination_ids).ids, filters)
    if order_items.nil?
      return []
    end

    ids = order_items.collect { |oi|
      oi.order_id
    }.uniq
    find({id: ids}, {id: orders})
  end

  #=============
  #handle
  #=============
  def self.handle ids, handled = true
    orders = Order.where(id: ids)
    orders.each { |o|
      #o.handled = handled
      #o.save
      o.update({handled: handled})
    }
  end

  #=============
  #get order history by start and end time
  #filt created_at
  #=============
  def self.history_orders_by_time args
    unless args[:start_time].class.name === "Time"
      args[:start_time] = Time.parse(args[:start_time]).at_beginning_of_day
      args[:end_time] = Time.parse(args[:end_time]).at_end_of_day
    end

    Order.where(user_id: args[:user_id], created_at: (args[:start_time]..args[:end_time])).all.order(created_at: :desc)
  end

  #=============
  # find
  # @params{}
  #=============
  def self.find condition, not_condition = {}
    Order.where(condition).where.not(not_condition).all
  end

  #=============
  #create order with order items
  #=============
  def self.create_with_items args, current_user
    order = Order.new(args[:order])
    order.user = current_user
    order.source_location_id = current_user.location_id
    order.remark = no_parts_to_string(args[:nopart_items])
    # order.handled=true
    ActiveRecord::Base.transaction do
      begin
        if order.save
          #save success
          #CREATE PICK
          pick=PickList.new(state: PickStatus::INIT)
          #TODO择货员？？？
          pick.user=current_user
          pick.remark="AUTO CREATE BY ORDER"

          args[:order_items].each do |item|
            part = OrderItemService.verify_part_id(item[:part_id], current_user)
            part_position = OrderItemService.verify_department(item[:department], item[:part_id])
            quantity = item[:quantity]
            box_quantity = item[:box_quantity]

            if item = OrderItemService.new(part_position, part, quantity, item[:is_emergency], box_quantity, current_user)
              item.order = order
              item.handled=true
              if item.save
                pick_item=PickItem.new(
                    #TODO择货员？？？
                    user_id: current_user.id,
                    destination_whouse_id: item.whouse_id,
                    part_id: item.part_id,
                    quantity: item.quantity,
                    state: PickStatus::INIT,
                    remark: "AUTO CREATE BY ORDER"
                )
                if position=Position.where(whouse_id: item.whouse_id, id: PartPosition.where(part_id: item.part_id).pluck(:position_id)).first
                  pick_item.position=position
                end
                pick_item.order_item=item
                pick.pick_items<<pick_item
                pick.orders<<order
              end
            end
          end

          pick.save
        else
          return nil
        end

      rescue ActiveRecord::RecordInvalid => invalid
        return nil
      end
    end
    return order
  end

  #=============
  #exits? id
  #=============
  def self.exits? id
    #search({id: id}).first
    find({id: id}).first
  end

  def self.no_parts_to_string items
    remark = ""
    puts items
    items.each { |item|
      puts item
      remark += "零件:"+item[:part_id]+",数量:"+item[:quantity].to_s+",箱数:"+item[:box_quantity].to_s+",部门:"+item[:department]+",是否加急:"+item[:is_emergency].to_s+"\n"
    } if items
    remark
  end

  #-------------
  #notify whouses
  #-------------
  def self.notify user
    condition = {}
    condition["orders.handled"] = false
    condition[:is_finished] = false
    condition[:out_of_stock] = false
    condition[:created_at] = Time.parse(1.day.ago.strftime("%Y-%m-%d 7:00:00")).utc..Time.now.utc
    condition["orders.source_id"] = user.location_id
    OrderItem.joins(:order).where(condition)
        .select("COUNT(order_items.part_id) as count,order_items.whouse_id as wid")
        .group("order_items.whouse_id").all
  end

  def self.create_by_led user, params
    validable_led_and_modem(params) do |part|
      order=Order.new(status: OrderStatus::INIT)
      order.user=user

      order_item=OrderItem.new({
                                   state: OrderStatus::INIT,
                                   quantity: params[:qty],
                                   part_id: part.id,
                                   is_emergency: 0
                               })
      order_item.user=user
      order_item.order=order

      if order_item.save && order.save
        {
            meta: {
                code: 200,
                message: 'Create Order Success'
            },
            data: OrderPresenter.new(order).as_basic_info
        }
      else
        ApiMessage.new({meta: {code: 400, error_message: '生成需求单失败'}})
      end
    end
  end

  # require
  #  nr:string
  def self.create_by_car user, params
    begin
      # Order.transaction do
      validable_car_and_box(params) do |car, boxs|
        order=Order.new(status: OrderStatus::INIT)
        order.user=user

        boxs.each do |box|
          order_item=OrderItem.new({
                                       state: OrderStatus::INIT,
                                       quantity: box.quantity,
                                       part_id: box.part_id,
                                       is_emergency: 0
                                   })
          order_item.user=user
          order_item.order=order
          box.order_items<<order_item
        end

        if order.save
          car.orders<<order
          {
              meta: {
                  code: 200,
                  message: 'Signed Success'
              },
              data: OrderPresenter.new(order).as_basic_info
          }
        else
          ApiMessage.new({meta: {code: 400, error_message: '生成需求单失败'}})
        end
      end
    end
    # rescue => e
    #   ApiMessage.new({meta: {code: 400, message: e.message}})
    # end
  end

  def self.move_stock_by_finish_pick id, user
    PickList.transaction do
      if pick = PickList.find_by_id(id)
        picked=true
        pick.pick_items.each do |pick_item|

          unless [PickItemStatus::BEFORE_PRINTED, PickItemStatus::PICKED].include?(pick_item.state)
            pick_item.update_attribute(:remark, "缺货")
            pick_item.order_item.update_attributes(handled: true, is_finished: false) if pick_item.order_item
            picked=false
            next
          end

          #move stock
          if from_wh=user.location.whouses.first
            pick_item.update_attribute(:remark, "已完成择货")










            pick_position = OrderItemService.verify_department(pick_item.destination_whouse_id, pick_item.part_id)
            WhouseService.new.move({
                                       employee_id: user.id,
                                       partNr: pick_item.part_id,
                                       qty: pick_item.quantity,
                                       fromWh: from_wh.id,
                                       toWh: pick_item.destination_whouse_id,
                                       toPosition: pick_item.position.blank? ? (pick_position.blank? ? "" : pick_position.position.detail) : pick_item.position.detail,
                                       remarks: "MOVE FROM PICK: #{pick_item.remark}"
                                   })

            if pick_item.order_item
              pick_item.order_item.update_attributes(handled: true, is_finished: true)
            end
          else
            raise "SRC WAREHOUSE Not Found"
          end

        end

        # if picked
          pick.update_attribute(:state, PickStatus::PICKED)
        pick.orders.first.update_attributes(status: OrderState::HANDLED, handled: true)
        # else
        #   pick.update_attribute(:state, PickStatus::PICKING)
        # end

        # pick.orders.each do |order|
        #   order.update_attribute(:handled, true)
        # end
      else
        raise "Pick List #{id} Not Found"
      end
    end
  end

  private
  def self.validable_led_and_modem params
    err_infos=[]
    part = nil
    if modem = Modem.find_by_ip(params[:ip])
      if (led = Led.where(nr: params[:led_id], modem_id: modem.id).first).blank?
        err_infos<<"LED灯:#{params[:led_id]}没有找到!"
      else
        if led.position && (part=led.position.parts.first)
        else
          err_infos<<"LED灯:#{params[:led_id]}不属于任何库位或者没有对应的零件!"
        end
      end
    else
      err_infos<<"控制器IP:#{params[:ip]}没有找到!"
    end

    if err_infos.size==0
      if block_given?
        yield(part)
      else
        ApiMessage.new({meta: {code: 200, message: '数据验证通过'}})
      end
    else
      ApiMessage.new({meta: {code: 400, message: err_infos.join(',')}})
    end
  end

  def self.validable_car_and_box params
    if car=OrderCar.find_by_id(params[:order_car_id])
      err_infos=[]
      boxs=[]
      params[:order_box_ids].each do |box_id|
        unless box=OrderBox.find_by_id(box_id)
          err_infos<<"料盒#{box_id}没有找到!"
        end
        boxs<<box
      end

      if err_infos.size==0
        if block_given?
          yield(car, boxs)
        else
          ApiMessage.new({meta: {code: 200, message: '数据验证通过'}})
        end
      else
        ApiMessage.new({meta: {code: 400, message: err_infos.join(',')}})
      end
    else
      ApiMessage.new({meta: {code: 400, message: '料车没有找到'}})
    end
  end
end
