module V1
  module Sync
    class LocationDestinationSyncAPI<SyncBase
      namespace 'location_destinations'
      rescue_from :all do |e|
        LocationDestinationSyncAPI.error_unlock_pool('location_destinations')
        Rack::Response.new([e.message],500).finish
      end

      get do
        LocationDestination.unscoped.where('updated_at>=?',params[:last_time]).all
      end

      post do
        msg = Message.new
        begin
          ActiveRecord::Base.transaction do
            location_destinations=JSON.parse(params[:location_destinations])
            location_destinations.each do |ld|
              l = LocationDestination,new(ld)
              l.save
            end
          end
            msg.result = true
        rescue => e
          msg.content = "post:#{e.message}"
        end
        return msg
      end

      put '/:id' do
        msg = Message.new
        begin
          ActiveRecord::Base.transaction do
            location_destinations = JSON.parse(params[:location_destinations])
            location_destinations.each do |ld|
              if l = LocationDestination.unscoped.find_by_id(ld['id'])
                l.update(ld.except('id'))
              end
            end
          end
          msg.result = true
        rescue => e
          msg.content = "put:#{e.message}"
        end
        return msg
      end

      post :delete do
        msg = Message.new
        begin
          ActiveRecord::Base.transaction do
            location_destinations = JSON.parse(params[:location_destinations])
            location_destinations.each do |id|
              if l = LocationDestination.unscoped.find_by_id(id)
                l.update(is_delete: true)
              end
            end
          end
          msg.result = true
        rescue => e
          msg.content = "delete:#{e.message}"
        end
        return msg
      end
    end
  end
end