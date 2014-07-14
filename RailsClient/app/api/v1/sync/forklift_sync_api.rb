module V1
  module Sync
    class ForkliftSyncAPI<SyncBase
      namespace 'forklifts'
      rescue_from :all do |e|
        ForkliftSyncAPI.error_unlock_sync_pool('forklifts')
        Rack::Response.new([e.message], 500).finish
      end

      get do
        Forklift.unscoped.where('updated_at>=?', params[:last_time]).all
      end

      post do
        forklifts=JSON.parse(params[:forklift])
        forklifts.each do |forklift|
          forklift=Forklift.new(forklift)
          forklift.save
        end
      end

      put '/:id' do
        forklifts=JSON.parse(params[:forklift])
        forklifts.each do |forklift|
          if u=Forklift.unscoped.find_by_id(forklift['id'])
            u.update(forklift.except('id'))
          end
        end
      end

      post :delete do
        forklifts=JSON.parse(params[:forklift])
        forklifts.each do |id|
          if forklift=Forklift.unscoped.find_by_id(id)
            forklift.update(is_delete: true)
          end
        end
      end
    end
  end
end