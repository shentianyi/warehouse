module V1
  module Sync
    class OrderItemSyncAPI<SyncBase
      namespace :order_items do
        rescue_from :all do |e|
          OrderItemSyncAPI.error_unlock_sync_pool('order_items')
          Rack::Response.new([e.message], 500).finish
        end
        get do
          OrderItem.unscoped.where('updated_at>=?', params[:last_time]).all
        end

        post do
          msg=Message.new
          begin
            ActiveRecord::Base.transaction do
              order_items=JSON.parse(params[:order_item])
              order_items.each do |order_item|
                order_item=OrderItem.new(order_item)
                order_item.save
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
              order_items=JSON.parse(params[:order_item])
              order_items.each do |order_item|
                if u=OrderItem.unscoped.find_by_id(order_item['id'])
                  u.update(order_item.except('id'))
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
              order_items=JSON.parse(params[:order_item])
              order_items.each do |id|
                if order_item=OrderItem.unscoped.find_by_id(id)
                  order_item.update(is_delete: true)
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
end