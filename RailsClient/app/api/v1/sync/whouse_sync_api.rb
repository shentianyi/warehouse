module V1
  module Sync
    class WhouseSyncAPI<SyncBase
      namespace 'whouses'

      rescue_from :all do |e|
        WhouseSyncAPI.error_unlock_sync_pool('whouses')
        Rack::Response.new([e.message], 500).finish
      end

      get do
        Whouse.unscoped.where('updated_at>=?', params[:last_time]).all
      end

      post do
        msg=Message.new
        begin
          ActiveRecord::Base.transaction do
            whouses=JSON.parse(params[:whouse])
            whouses.each do |whouse|
              whouse=Whouse.new(whouse)
              whouse.save
            end
          end
          msg.result =true
        rescue => e
          msg.content = "put:#{e.message}"
        end
        return msg
      end

      put '/:id' do
        msg=Message.new
        begin
          ActiveRecord::Base.transaction do
            whouses=JSON.parse(params[:whouse])
            whouses.each do |whouse|
              if u=Whouse.unscoped.find_by_id(whouse['id'])
                u.update(whouse.except('id'))
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
            whouses=JSON.parse(params[:whouse])
            whouses.each do |id|
              if whouse=Whouse.unscoped.find_by_id(id)
                whouse.update(is_delete: true)
              end
            end
          end
          msg.result =true
        rescue => e
          msg.content = "put:#{e.message}"
        end
        return msg
      end
    end
  end
end