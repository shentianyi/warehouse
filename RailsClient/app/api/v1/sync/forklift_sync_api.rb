module V1
  module Sync
    class ForkliftSyncAPI<SyncBase
      namespace 'forklifts'
      get do
        Forklift.unscoped.where('updated_at>=?', params[:last_time]).all
      end

      post do
        puts params
        forklift=forklift.new(JSON.parse(params[:forklift]))
        forklift.save
        forklift
      end

      put '/:id' do
        if forklift=forklift.find_by_id(params[:id])
          forklift.update(JSON.parse(params[:forklift]))
        end
        forklift
      end

      delete '/:id' do
        puts params
        puts params[:forklift]
        if forklift=forklift.find_by_id(params[:id])
          forklift.update(is_delete: true)
        end
        forklift
      end
    end
  end
end