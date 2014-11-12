module V1
  class OrderAPI<Base
    namespace :orders
    guard_all!

    #strong parameters
    helpers do
      def order_params
        ActionController::Parameters.new(params).require(:order).permit(:id,:source_id,:user_id,:remark)
      end
    end

    #=============
    #get history of orders
    #post start and end time(local time)
    #=============
    get :history do
      #args = {
      #    start_time:params[:start],
      #    end_time:params[:end]
      #}
      #args[:user_id] = params[:user_id].nil? ? current_user.id : params[:user_id]

      #new params
      condition = {}
      condition[:user_id] = params[:user_id].nil? ? current_user.id : params[:user_id]
      starttime = params[:start]
      endtime = params[:end]
      unless starttime.class.name === 'Time'
        starttime = Time.parse(starttime).at_beginning_of_day
        endtime = Time.parse(endtime).at_end_of_day
      end
      condition[:created_at] = (starttime..endtime)

      orders = []
      OrderPresenter.init_presenters(OrderService.find(condition).all.order(created_at: :desc)).each do |op|
        orders<<op.to_json
      end
      return {result:1,content:{orders:orders}}
    end

    #=============
    #get order detail(order item) by order id
    #=============
    get do
      unless order = OrderService.exits?(params[:id])
        return {result:0,content:OrderMessage::NotFound}
      end
      return {result:1,content:{order:OrderPresenter.new(order).to_json_with_order_items}}
    end

    #=============
    #create order with order items
    #before doing this, order item should be
    #verified
    #=============
    post do
      unless order = OrderService.create_with_items({order:order_params,order_items:params[:order_items],nopart_items:params[:nopart_items]},current_user)
        return {result:0,content:OrderMessage::CreatedFailed}
      end

      return {result:1,content:OrderPresenter.new(order).to_json}
    end

    #=============
    #delete order
    #=============
    delete do
      unless order = OrderService.exits?(params[:id])
        return {result:0,content:OrderMessage::NotFound}
      end

      order.destroy
      return {result:1,content:OrderMessage::DeleteSuccess}
    end

    #=============
    #check part in order
    #=============
    get :check_part do
      unless part = OrderItemService.verify_part_id(params[:part_id],current_user)
        return {result:0,content:OrderItemMessage::PartIDError}
      end

      unless part_position = OrderItemService.verify_department(params[:department],params[:part_id])
        return {result:0,content:OrderItemMessage::DepartmentError}
      end
      count = params.has_key?(:count) ? params[:count] : 5
      orders = Order.includes(:order_items).where('order_items.part_id' => part.id, 'orders.user_id' => current_user.id).limit(count).order(created_at: :desc)
      res_orders = []
      orders.each do |o|
        order = {id:o.id,created_at:o.created_at.localtime.strftime('%Y-%m-%d %H:%M:%S')}
        order['order_items'] = []
        o.order_items.where('part_id' > 'part_id').each do |oi|
          order['order_items'] << {id:oi.id,part_id:oi.part_id,box_quantity:oi.box_quantity,quantity:oi.quantity,is_emergency:oi.is_emergency ? 1:0}
        end
        res_orders<<order
      end
      {result:1,content:res_orders}
    end
  end
end
