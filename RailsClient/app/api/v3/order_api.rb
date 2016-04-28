
#encoding: utf-8
module V3
  class OrderApi <Base
    guard_all!
    
    namespace :orders do
      format :json
      rescue_from :all do |e|
        Rack::Response.new([e.message], 500).finish
      end

      params do
        requires :id, type: String, desc: 'order id'
      end
      get do
        if order=Order.find_by_id(params[:id])
          {
              result: 1,
              content: OrderPresenter.new(order).to_json
          }
        else
          {result: 0, content: "需求单不存在!"}
        end
      end


      get :recent do
       {
           result:1,
           content: OrderPresenter.init_json_presenters(Order.order('created_at desc').limit(10).all)
       }
      end
    end
  end
end