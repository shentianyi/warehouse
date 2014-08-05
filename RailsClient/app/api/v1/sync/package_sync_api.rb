module V1
  module Sync
    class PackageSyncAPI<SyncBase
      namespace 'packages'
      rescue_from :all do |e|
        PackageSyncAPI.error_unlock_sync_pool('packages')
        Rack::Response.new([e.message], 500).finish
      end
      get do
        Package.unscoped.where('updated_at>=?', params[:last_time]).all
      end

      post do
        msg=Message.new
        begin
          ActiveRecord::Base.transaction do
            packages=JSON.parse(params[:package])
            packages.each do |package|
              package=Package.new(package)
              package.save
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
            packages=JSON.parse(params[:package])
            puts packages.count
            packages.each do |package|
              if u=Package.unscoped.find_by_id(package['id'])
                u.update(package.except('id'))
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
            packages=JSON.parse(params[:package])
            packages.each do |id|
              if package=Package.unscoped.find_by_id(id)
                package.update(is_delete: true)
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