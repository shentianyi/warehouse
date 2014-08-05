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
        msg=Message.new
        begin
          ActiveRecord::Base.transaction do
            orders=JSON.parse(params[:order])
            orders.each do |order|
              order=Order.new(order)
              order.save
            end
          end
          msg.result =true
        rescue => e
          msg.content = "post:#{e.message}"
        end
        return msg
      end

      put '/:id' do
        msg=Message.new
        begin
          ActiveRecord::Base.transaction do
            orders=JSON.parse(params[:order])
            orders.each do |order|
              if u=Order.unscoped.find_by_id(order['id'])
                u.update(order.except('id'))
              end
            end
          end

          msg.result =true
        rescue => e
          msg.content = "put:#{e.message}"
        end
        return msg
      end

      post :delete do
        msg=Message.new
        begin
          ActiveRecord::Base.transaction do
            orders=JSON.parse(params[:order])
            orders.each do |id|
              if order=Order.unscoped.find_by_id(id)
                order.update(is_delete: true)
              end
            end
          end
          msg.result =true
        rescue => e
          msg.content = "delete:#{e.message}"
        end
        return msg
      end
    end
  end
end