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
      find({created_at: (start_time..end_time), user_id: user_id, handled: handled, source_location_id: location_ids})
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
    order_items = PickItemService.get_order_items(user_id,
                                                  get_orders_by_days(user.location_destination_ids).ids, filters)
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

    p '-----------------'

  p  args[:order_items]
    p '-------------------'
    if args[:order][:source_id].blank?
      if l=OrderItemService.verify_location(current_user)
        args[:order][:source_id]=l.id
      end
    end
    order = Order.new(args[:order])
    order.user = current_user
    order.source_location_id = current_user.location_id
    order.remark = no_parts_to_string(args[:nopart_items])

    ActiveRecord::Base.transaction do
      begin
        if order.save
          #save success
          args[:order_items].each do |item|
            part = OrderItemService.verify_user_part(item[:part_id], current_user)
            location = OrderItemService.verify_location(current_user)
            quantity = item[:quantity]
            box_quantity = item[:box_quantity]

            if item = OrderItemService.new(location, part, quantity, item[:is_emergency], box_quantity, current_user)
              item.order = order
              item.save
            end
          end
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
    items.each { |item|
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
end
