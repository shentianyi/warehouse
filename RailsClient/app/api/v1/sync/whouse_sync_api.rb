module V1
  module Sync
    class ShouseSyncAPI<SyncBase
      namespace 'whouses'

      get do
        Whouse.unscoped.where('updated_at>=?', params[:last_time]).all
      end

      post do
        whouses=JSON.parse(params[:whouse])
        whouses.each do |whouse|
          whouse=Whouse.new(whouse)
          puts whouse
          whouse.save
        end
      end

      put '/:id' do
        whouses=JSON.parse(params[:whouse])
        whouses.each do |whouse|
          if u=Whouse.unscoped.find_by_id(whouse['id'])
            u.update(whouse.except('id'))
          end
        end
      end

      post :delete do
        whouses=JSON.parse(params[:whouse])
        whouses.each do |id|
          if whouse=Whouse.unscoped.find_by_id(id)
            whouse.update(is_delete: true)
          end
        end
      end
    end
  end
end