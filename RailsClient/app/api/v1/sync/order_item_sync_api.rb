module V1
  module Sync
    class OrderItemSyncAPI<SyncBase
      namespace 'order_items'
      rescue_from :all do |e|
        OrderItemSyncAPI.error_unlock_sync_pool('order_items')
        Rack::Response.new([e.message], 500).finish
      end
      get do
        OrderItem.unscoped.where('updated_at>=?', params[:last_time]).all
      end

      post do
        order_items=JSON.parse(params[:order_item])
        order_items.each do |order_item|
          order_item=OrderItem.new(order_item)
          order_item.save
        end
      end

      put '/:id' do
        order_items=JSON.parse(params[:order_item])
        order_items.each do |order_item|
          if u=OrderItem.unscoped.find_by_id(order_item['id'])
            u.update(order_item.except('id'))
          end
        end
      end

      post :delete do
        order_items=JSON.parse(params[:order_item])
        order_items.each do |id|
          if order_item=OrderItem.unscoped.find_by_id(id)
            order_item.update(is_delete: true)
          end
        end
      end
    end
  end
end