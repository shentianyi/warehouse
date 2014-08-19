module V1
  module Sync
    class ForkliftSyncAPI<SyncBase
      namespace 'forklifts'
      rescue_from :all do |e|
        ForkliftSyncAPI.error_unlock_sync_pool('forklifts')
        Rack::Response.new([e.message], 500).finish
      end

      get do
        Forklift.unscoped.where('updated_at>=?', params[:last_time]).all
      end

      post do
        msg=Message.new
        begin
          ActiveRecord::Base.transaction do
            forklifts=JSON.parse(params[:forklift])
            forklifts.each do |forklift|
              forklift=Forklift.new(forklift)
              forklift.save
            end
          end
          msg.result =true
        rescue => e
          msg.content = "post:#{e.message}"
        end
        return msg
        #ActiveRecord::Base.transaction do
        #  forklifts=JSON.parse(params[:forklift])
        #  forklifts.each do |forklift|
        #    forklift=Forklift.new(forklift)
        #    forklift.save
        #  end
        #end
      end

      put '/:id' do
        msg=Message.new
        begin
          ActiveRecord::Base.transaction do
            forklifts=JSON.parse(params[:forklift])
            forklifts.each do |forklift|
              if u=Forklift.unscoped.find_by_id(forklift['id'])
                u.update(forklift.except('id'))
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
            forklifts=JSON.parse(params[:forklift])
            forklifts.each do |id|
              if forklift=Forklift.unscoped.find_by_id(id)
                forklift.update(is_delete: true)
              end
            end
          end
          msg.result =true
        rescue => e

          msg.content = "#{this}:#{e.message}"
        end
        return msg
      end
    end
  end
end