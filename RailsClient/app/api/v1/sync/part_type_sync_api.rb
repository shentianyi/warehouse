module V1
  module Sync
    class PartTypeSyncAPI<SyncBase
      namespace 'part_types'
      rescue_from :all do |e|
        PartTypeSyncAPI.error_unlock_sync_pool('part_types')
        Rack::Response.new([e.message], 500).finish
      end
      get do
        PartType.unscoped.where('updated_at>=?', Time.parse(params[:last_time])).all
      end

      post do
        part_types=JSON.parse(params[:part_type])
        part_types.each do |part_type|
          part_type=PartType.new(part_type)
          part_type.save
        end
      end

      put '/:id' do
        part_types=JSON.parse(params[:part_type])
        part_types.each do |part_type|
          if u=PartType.unscoped.find_by_id(part_type['id'])
            u.update(part_type.except('id'))
          end
        end
      end

      post :delete do
        part_types=JSON.parse(params[:part_type])
        part_types.each do |id|
          if part_type=PartType.unscoped.find_by_id(id)
            part_type.update(is_delete: true)
          end
        end
      end
    end
  end
end