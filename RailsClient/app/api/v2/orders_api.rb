module V2
  class OrdersApi<Base
    namespace :orders
    guard_all!

    helpers do
      def order_params
        ActionController::Parameters.new(params).require(:order).permit(:id,:source_id,:user_id,:remark)
      end
    end

    #=============
    # url: GET /orders
    #=============
    get do
      pa = ParamsService.parse_to_search(params)
      OrderPresenter.init_json_presenters(OrderService.where(pa[:args]).order(pa[:sort]).limit(pa[:limit]))
    end
  end
end