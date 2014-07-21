class OrderService

  #=============
  #get order history by start and end time
  #filt created_at
  #=============
  def self.order_history_by_time args
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
end