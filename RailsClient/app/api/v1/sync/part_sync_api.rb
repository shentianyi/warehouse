module V1
  module Sync
    class PartSyncAPI<SyncBase
      namespace 'parts'

      get do
        Part.unscoped.where('updated_at>=?', params[:last_time]).all
      end

      post do
        parts=JSON.parse(params[:part])
        parts.each do |part|
          part=Part.new(part)
          puts part
          part.save
        end
      end

      put '/:id' do
        parts=JSON.parse(params[:part])
        parts.each do |part|
          if u=Part.unscoped.find_by_id(part['id'])
            u.update(part.except('id'))
          end
        end
      end

      post :delete do
        parts=JSON.parse(params[:part])
        parts.each do |id|
          if part=Part.unscoped.find_by_id(id)
            part.update(is_delete: true)
          end
        end
      end
    end
  end
end