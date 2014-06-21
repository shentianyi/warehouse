module V1
  module Sync
    class LocationSyncAPI<SyncBase
      namespace 'locations'
      #rescue_from :all do |e|
      #  LocationSyncAPI.error_unlock_sync_pool('locations')
      #  Rack::Response.new([e.message], 500).finish
      #end

      get do
        Location.unscoped.where('updated_at>=?', params[:last_time]).all
      end

      post do
        locations=JSON.parse(params[:location])
        locations.each do |location|
          location=Location.new(location)
          puts location
          location.save
        end
      end

      put '/:id' do
        locations=JSON.parse(params[:location])
        locations.each do |location|
          if u=Location.unscoped.find_by_id(location['id'])
            u.update(location.except('id'))
          end
        end
      end

      post :delete do
        locations=JSON.parse(params[:location])
        locations.each do |id|
          if location=Location.unscoped.find_by_id(id)
            location.update(is_delete: true)
          end
        end
      end
    end
  end
end