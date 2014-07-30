module V1
  class OrderAPI<Base
    namespace :orders
    guard_all!

    #strong parameters
    helpers do
      def order_params
        ActionController::Parameters.new(params).require(:order).permit(:id,:source_id,:user_id)
      end
    end

    #=============
    #get history of orders
    #post start and end time(local time)
    #=============
    get :history do
      args = {
          start_time:params[:start],
          end_time:params[:end]
      }
      args[:user_id] = params[:user_id].nil? ? current_user.id : params[:user_id]

      orders = []
      OrderPresenter.init_presenters(OrderService.history_orders_by_time(args)).each do |op|
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
      puts params.to_json
      unless order = OrderService.create_with_items({order:order_params,order_items:params[:order_items]},current_user)
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
  end
end