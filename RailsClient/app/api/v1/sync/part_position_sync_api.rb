module V1
  module Sync
    class PartPositionSyncAPI<SyncBase
      namespace :part_positions do
        rescue_from :all do |e|
          PartPositionSyncAPI.error_unlock_sync_pool('part_positions')
          Rack::Response.new([e.message], 500).finish
        end

        get do
          PartPosition.unscoped.where('updated_at>=?', params[:last_time]).all
        end

        post do
          msg=Message.new
          begin
            ActiveRecord::Base.transaction do
              part_positions=JSON.parse(params[:part_position])
              part_positions.each do |part_position|
                unless PartPosition.unscoped.where(PartPosition.fk_condition(part_position)).first
                  part_position=PartPosition.new(part_position)
                  part_position.save
                end
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
              part_positions=JSON.parse(params[:part_position])
              part_positions.each do |part_position|
                if u=PartPosition.unscoped.where(PartPosition.fk_condition(part_position)).first
                  u.update(part_position.except(PartPosition::FK, 'id'))
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
              part_positions=JSON.parse(params[:part_position])
              part_positions.each do |part_position|
                if part_position=PartPosition.unscoped.where(PartPosition.fk_condition(part_position)).first
                  part_position.update(is_delete: true)
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
end