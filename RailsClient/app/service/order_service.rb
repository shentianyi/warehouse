class OrderService

  #=============
  #get order history by start and end time
  #filt created_at
  #=============
  def self.history_orders_by_time args
    unless args[:start_time].class.name === "Time"
      args[:start_time] = Time.parse(args[:start_time])
      args[:end_time] = Time.parse(args[:end_time])
    end

    Order.where(user_id:args[:user_id],created_at:(args[:start_time]..args[:end_time])).all.order(created: :desc)
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
    order = Order.new(args[:order])
    order.user = current_user
    if order.save
      #save success
      ActiveRecord::Base.transaction do
        begin
          args[:order_items].each do |order_item|
            item = OrderItemService.create(item,current_user)
            item.order = order
            item.save
          end
        rescue ActiveRecord::RecordInvalid => invalid
          return nil
        end
      end
      return order
    else
      return nil
    end
  end

  #=============
  #exits? id
  #=============
  def self.exits? id
    search({id:id}).first
  end
end