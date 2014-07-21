module V1
  class OrderAPI<Base
    namespace :order
    guard_all!

    #strong parameters
    helers do
      def order_params
        ActivonController::Parameters.new(params).require(:order).permit(:id,:user_id)
      end
    end

    #=============
    #get history of orders
    #post start and end time
    #=============
    post :history do
      args = {
          start_time:params[:start],
          end_time:params[:end],
          user_id:current_user.id
      }

      orders = []
      OrderPresenter.init_presenters(OrderService.order_history_by_time(args)).each do |op|
        orders<<op.to_json
      end

      {result:1,content:{orders:orders}}
    end

    #=============
    #get order detail(order item) by order id
    #=============
    get do
      unless order = Order.find_by_id (params[:id])
        return {result:0,content:OrderMessage::NotFound}
      end
      return {result:1,content:{order:OrderPresenter.new(order).to_json_with_order_items}}
    end

    #=============
    #create order with order items
    #=============
    post do
      
    end
  end
end