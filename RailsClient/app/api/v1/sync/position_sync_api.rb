module V1
  module Sync
    class PositionSyncAPI<SyncBase
      namespace 'positions'
      rescue_from :all do |e|
        PositionSyncAPI.error_unlock_sync_pool('positions')
        Rack::Response.new([e.message], 500).finish
      end
      get do
        Position.unscoped.where('updated_at>=?', params[:last_time]).all
      end

      post do
        msg=Message.new
        begin
          ActiveRecord::Base.transaction do
            positions=JSON.parse(params[:position])
            positions.each do |position|
              position=Position.new(position)
              position.save
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
            positions=JSON.parse(params[:position])
            positions.each do |position|
              if u=Position.unscoped.find_by_id(position['id'])
                u.update(position.except('id'))
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
            positions=JSON.parse(params[:position])
            positions.each do |id|
              if position=Position.unscoped.find_by_id(id)
                position.update(is_delete: true)
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