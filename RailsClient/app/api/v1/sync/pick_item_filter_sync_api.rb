module V1
  module Sync
    class PickItemFilterSyncAPI<SyncBase
      namespace 'pick_item_filters'
      rescue_from :all do |e|
        PickItemFilterSyncAPI.error_unlock_sync_pool('pick_item_filters')
        Rack::Response.new([e.message], 500).finish
      end
      get do
        PickItemFilter.unscoped.where('updated_at>=?', params[:last_time]).all
      end

      post do
        msg=Message.new
        begin
          ActiveRecord::Base.transaction do
            pick_item_filters=JSON.parse(params[:pick_item_filter])
            pick_item_filters.each do |pick_item_filter|
              pick_item_filter=PickItemFilter.new(pick_item_filter)
              pick_item_filter.save
            end
          end
          msg.result =true
        rescue => e
          msg.content = "delete:#{e.message}"
        end
        return msg
      end

      put '/:id' do
        msg=Message.new
        begin
          ActiveRecord::Base.transaction do
            pick_item_filters=JSON.parse(params[:pick_item_filter])
            pick_item_filters.each do |pick_item_filter|
              if u=PickItemFilter.unscoped.find_by_id(pick_item_filter['id'])
                u.update(pick_item_filter.except('id'))
              end
            end
          end
          msg.result =true
        rescue => e
          msg.content = "delete:#{e.message}"
        end
        return msg
      end

      post :delete do
        msg=Message.new
        begin
          ActiveRecord::Base.transaction do
            pick_item_filters=JSON.parse(params[:pick_item_filter])
            pick_item_filters.each do |id|
              if pick_item_filter=PickItemFilter.unscoped.find_by_id(id)
                pick_item_filter.update(is_delete: true)
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