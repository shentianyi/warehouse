class OrderService

  #=============
  #get last n days order
  #params
  # @user_id:current_user.id,
  # @current_user: get location id
  # @days: integer
  # @state: false
  #=============
  def self.get_orders_by_days location_id,days=7,handled = false,user_id = nil
    start_time = days.days.ago.at_beginning_of_day.utc
    end_time = Time.now.at_end_of_day.utc
    if user_id.nil?
      Order.where(created_at:(start_time..end_time),handled:handled,source_id:location_id).all.order(created_at: :desc)
    else
      Order.where(created_at:(start_time..end_time),user_id:user_id,handled:handled,source_id:location_id).all.order(created_at: :desc)
    end
  end

  #=============
  #handle
  #=============
  def self.handle ids,handled = true
    orders = Order.where(id: ids)
    orders.each {|o|
      o.handled = handled
      o.save
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

    Order.where(user_id:args[:user_id],created_at:(args[:start_time]..args[:end_time])).all.order(created_at: :desc)
  end

  #=============
  #search
  #=============
  def self.search args
    Order.where(args).all.order(created_at: :desc)
  end

  #=============
  #create order with order items
  #=============
  def self.create_with_items args,current_user
    puts args.to_json
    puts args[:order].to_json
    order = Order.new(args[:order])
    order.user = current_user
    ActiveRecord::Base.transaction do
      begin
        if order.save
          #save success
          args[:order_items].each do | item |
            if item = OrderItemService.new(item,current_user)
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
    search({id:id}).first
  end
end