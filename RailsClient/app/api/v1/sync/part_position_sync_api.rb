module V1
  module Sync
    class PartPositionSyncAPI<SyncBase
      namespace 'part_positions'
      #rescue_from :all do |e|
      #  PartPositionSyncAPI.error_unlock_sync_pool('part_positions')
      #  Rack::Response.new([e.message], 500).finish
      #end

      get do
        PartPosition.unscoped.where('updated_at>=?', params[:last_time]).all
      end

      post do
        puts params
        part_positions=JSON.parse(params[:part_position])
        part_positions.each do |part_position|
          part_position=PartPosition.new(part_position)
          puts part_position
          part_position.save
        end
      end

      put '/:id' do
        part_positions=JSON.parse(params[:part_position])
        part_positions.each do |part_position|
          if u=PartPosition.unscoped.where(PartPosition.fk_condition(part_position)).first
            u.update(part_position.except(PartPosition::FK, 'id'))
          end
        end
      end

      post :delete do
        part_positions=JSON.parse(params[:part_position])
        part_positions.each do |id|
          if part_position=PartPosition.unscoped.where(PartPosition.fk_condition(part_position)).first
            part_position.update(is_delete: true)
          end
        end
      end
    end
  end
end