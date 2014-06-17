module V1
  module Sync
    class PositionSyncAPI<SyncBase
      namespace 'positions'

      get do
        Position.unscoped.where('updated_at>=?', params[:last_time]).all
      end

      post do
        positions=JSON.parse(params[:position])
        positions.each do |position|
          position=Position.new(position)
          puts position
          position.save
        end
      end

      put '/:id' do
        positions=JSON.parse(params[:position])
        positions.each do |position|
          if u=Position.unscoped.find_by_id(position['id'])
            u.update(position.except('id'))
          end
        end
      end

      post :delete do
        positions=JSON.parse(params[:position])
        positions.each do |id|
          if position=Position.unscoped.find_by_id(id)
            position.update(is_delete: true)
          end
        end
      end
    end
  end
end