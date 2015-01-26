module V1
  module Sync
    class StorageSyncAPI<SyncBase
      namespace 'storages'
      rescue_from :all do |e|
        StorageSyncAPI.error_unlock_sync_pool('storages')
        Rack::Response.new([e.message], 500).finish
      end
      
      get do
        Storage.unscoped.where('updated_at>=?', params[:last_time]).all
      end

      post do
        msg=Message.new
        begin
          ActiveRecord::Base.transaction do
            storages=JSON.parse(params[:storage])
            storages.each do |storage|
              storage=Storage.new(storage)
              storage.save
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
            storages=JSON.parse(params[:storage])
            puts storages.count
            storages.each do |storage|
              if u=Storage.unscoped.find_by_id(storage['id'])
                u.update(storage.except('id'))
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
            storages=JSON.parse(params[:storage])
            storages.each do |id|
              if storage=Storage.unscoped.find_by_id(id)
                storage.update(is_delete: true)
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