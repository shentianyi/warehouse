module V1
  module Sync
    class RecordSyncAPI<SyncBase
      namespace 'records'
      rescue_from :all do |e|
        RecordSyncAPI.error_unlock_sync_pool('records')
        Rack::Response.new([e.message], 500).finish
      end
      
      get do
        Record.unscoped.where('updated_at>=?', params[:last_time]).all
      end

      post do
        msg=Message.new
        begin
          ActiveRecord::Base.transaction do
            records=JSON.parse(params[:record])
            records.each do |record|
              record=Record.new(record)
              record.save
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
            records=JSON.parse(params[:record])
            puts records.count
            records.each do |record|
              if u=Record.unscoped.find_by_id(record['id'])
                u.update(record.except('id'))
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
            records=JSON.parse(params[:record])
            records.each do |id|
              if record=Record.unscoped.find_by_id(id)
                record.update(is_delete: true)
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