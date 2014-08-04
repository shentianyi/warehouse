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
        pick_item_filters=JSON.parse(params[:pick_item_filter])
        pick_item_filters.each do |pick_item_filter|
          pick_item_filter=PickItemFilter.new(pick_item_filter)
          pick_item_filter.save
        end
      end

      put '/:id' do
        pick_item_filters=JSON.parse(params[:pick_item_filter])
        pick_item_filters.each do |pick_item_filter|
          if u=PickItemFilter.unscoped.find_by_id(pick_item_filter['id'])
            u.update(pick_item_filter.except('id'))
          end
        end
      end

      post :delete do
        pick_item_filters=JSON.parse(params[:pick_item_filter])
        pick_item_filters.each do |id|
          if pick_item_filter=PickItemFilter.unscoped.find_by_id(id)
            pick_item_filter.update(is_delete: true)
          end
        end
      end
    end
  end
end