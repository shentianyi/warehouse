module V1
  module Sync
    class StateLogSyncAPI<SyncBase
      namespace 'state_logs'
      #rescue_from :all do |e|
      #  StateLogSyncAPI.error_unlock_sync_pool('state_logs')
      #  Rack::Response.new([e.message], 500).finish
      #end
      get do
        StateLog.unscoped.where('updated_at>=?', params[:last_time]).all
      end

      post do
        state_logs=JSON.parse(params[:state_log])
        state_logs.each do |state_log|
          state_log=StateLog.new(state_log)
          state_log.save
        end
      end

      put '/:id' do
        state_logs=JSON.parse(params[:state_log])
        state_logs.each do |state_log|
          if u=StateLog.unscoped.find_by_id(state_log['id'])
            u.update(state_log.except('id'))
          end
        end
      end

      post :delete do
        state_logs=JSON.parse(params[:state_log])
        state_logs.each do |id|
          if state_log=StateLog.find_by_id(id)
            state_log.update(is_delete: true)
          end
        end
      end
    end
  end
end