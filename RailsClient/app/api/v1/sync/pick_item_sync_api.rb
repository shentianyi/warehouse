module V1
  module Sync
    class PickItemSyncAPI<SyncBase
      namespace 'pick_items'
      rescue_from :all do |e|
        PickItemSyncAPI.error_unlock_sync_pool('pick_items')
        Rack::Response.new([e.message], 500).finish
      end
      get do
        PickItem.unscoped.where('updated_at>=?', params[:last_time]).all
      end

      post do
        msg=Message.new
        begin
          ActiveRecord::Base.transaction do
            pick_items=JSON.parse(params[:pick_item])
            pick_items.each do |pick_item|
              pick_item=PickItem.new(pick_item)
              pick_item.save
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
            pick_items=JSON.parse(params[:pick_item])
            pick_items.each do |pick_item|
              if u=PickItem.unscoped.find_by_id(pick_item['id'])
                u.update(pick_item.except('id'))
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
            pick_items=JSON.parse(params[:pick_item])
            pick_items.each do |id|
              if pick_item=PickItem.unscoped.find_by_id(id)
                pick_item.update(is_delete: true)
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