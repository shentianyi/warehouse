module V1
  module Sync
    class OrderSyncAPI<SyncBase
      namespace 'orders'
      rescue_from :all do |e|
        OrderSyncAPI.error_unlock_sync_pool('orders')
        Rack::Response.new([e.message], 500).finish
      end
      get do
        Order.unscoped.where('updated_at>=?', params[:last_time]).all
      end

      post do
        orders=JSON.parse(params[:order])
        orders.each do |order|
          order=Order.new(order)
          order.save
        end
      end

      put '/:id' do
        orders=JSON.parse(params[:order])
        orders.each do |order|
          if u=Order.unscoped.find_by_id(order['id'])
            u.update(order.except('id'))
          end
        end
      end

      post :delete do
        orders=JSON.parse(params[:order])
        orders.each do |id|
          if order=Order.unscoped.find_by_id(id)
            order.update(is_delete: true)
          end
        end
      end
    end
  end
end