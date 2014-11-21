module V1
  module Sync
    class LocationContainerSyncAPI<SyncBase
      namespace 'location_containers'
      rescue_from :all do |e|
        LocationContainerSyncAPI.error_unlock_sync_pool('location_containers')
        Rack::Response.new([e.message], 500).finish
      end
      
      get do
        LocationContainer.unscoped.where('updated_at>=?', params[:last_time]).all
      end

      post do
        msg=Message.new
        begin
          ActiveRecord::Base.transaction do
            location_containers=JSON.parse(params[:location_container])
            location_containers.each do |location_container|
              location_container=LocationContainer.new(location_container)
              location_container.save
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
            location_containers=JSON.parse(params[:location_container])
            puts location_containers.count
            location_containers.each do |location_container|
              if u=LocationContainer.unscoped.find_by_id(location_container['id'])
                u.update(location_container.except('id'))
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
            location_containers=JSON.parse(params[:location_container])
            location_containers.each do |id|
              if location_container=LocationContainer.unscoped.find_by_id(id)
                location_container.update(is_delete: true)
              end
            end
          end
          msg.result =true
        rescue => e
          msg.content = "post:#{e.message}"
        end
        return msg
      end
    end
  end
end