module V1
  module Sync
    class PartSyncAPI<SyncBase
      namespace 'parts'
      rescue_from :all do |e|
        PartSyncAPI.error_unlock_sync_pool('parts')
        Rack::Response.new([e.message], 500).finish
      end
      get do
        Part.unscoped.where('updated_at>=?', Time.parse(params[:last_time])).all
      end

      post do
        msg=Message.new
        begin
          ActiveRecord::Base.transaction do
            parts=JSON.parse(params[:part])
            parts.each do |part|
              part=Part.new(part)
              part.save
            end
          end
          msg.result =true
        rescue => e
          msg.content = "delete:#{e.message}"
        end
        return msg
      end

      put '/:id' do
        msg=Message.new
        begin
          ActiveRecord::Base.transaction do
            parts=JSON.parse(params[:part])
            parts.each do |part|
              if u=Part.unscoped.find_by_id(part['id'])
                u.update(part.except('id'))
              end
            end
          end
          msg.result =true
        rescue => e
          msg.content = "delete:#{e.message}"
        end
        return msg
      end

      post :delete do
        msg=Message.new
        begin
          ActiveRecord::Base.transaction do
            parts=JSON.parse(params[:part])
            parts.each do |id|
              if part=Part.unscoped.find_by_id(id)
                part.update(is_delete: true)
              end
            end
          end
          msg.result =true
        rescue => e
          msg.content = "delete:#{e.message}"
        end
        return msg
      end
    end
  end
end