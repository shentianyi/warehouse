module V1
  module Sync
    class PickListSyncAPI<SyncBase
      namespace 'pick_lists'
      rescue_from :all do |e|
        PickListSyncAPI.error_unlock_sync_pool('pick_lists')
        Rack::Response.new([e.message], 500).finish
      end
      get do
        PickList.unscoped.where('updated_at>=?', params[:last_time]).all
      end

      post do
        pick_lists=JSON.parse(params[:pick_list])
        pick_lists.each do |pick_list|
          pick_list=PickList.new(pick_list)
          pick_list.save
        end
      end

      put '/:id' do
        pick_lists=JSON.parse(params[:pick_list])
        pick_lists.each do |pick_list|
          if u=PickList.unscoped.find_by_id(pick_list['id'])
            u.update(pick_list.except('id'))
          end
        end
      end

      post :delete do
        pick_lists=JSON.parse(params[:pick_list])
        pick_lists.each do |id|
          if pick_list=PickList.unscoped.find_by_id(id)
            pick_list.update(is_delete: true)
          end
        end
      end
    end
  end
end