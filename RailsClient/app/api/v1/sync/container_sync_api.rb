module V1
  module Sync
    class ContainerSyncAPI<SyncBase
      namespace :containers do
        rescue_from :all do |e|
          ContainerSyncAPI.error_unlock_sync_pool('containers')
          Rack::Response.new([e.message], 500).finish
        end

        get do
          Container.unscoped.where('updated_at>=?', params[:last_time]).all
        end

        post do
          msg=Message.new
          begin
            ActiveRecord::Base.transaction do
              containers=JSON.parse(params[:container])
              containers.each do |container|
                container=Container.new(container)
                container.save
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
              containers=JSON.parse(params[:container])
              puts containers.count
              containers.each do |container|
                if u=Container.unscoped.find_by_id(container['id'])
                  u.update(container.except('id'))
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
              containers=JSON.parse(params[:container])
              containers.each do |id|
                if container=Container.unscoped.find_by_id(id)
                  container.update(is_delete: true)
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
end