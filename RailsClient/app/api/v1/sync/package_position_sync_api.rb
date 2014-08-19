module V1
  module Sync
    class PackagePositionSyncAPI<SyncBase
      namespace 'package_positions'
      rescue_from :all do |e|
        PackagePositionSyncAPI.error_unlock_sync_pool('package_positions')
        Rack::Response.new([e.message], 500).finish
      end

      get do
        PackagePosition.unscoped.where('updated_at>=?', params[:last_time]).all
      end

      post do
        msg=Message.new
        begin
          ActiveRecord::Base.transaction do
            package_positions=JSON.parse(params[:package_position])
            package_positions.each do |package_position|
              unless PackagePosition.unscoped.where(PackagePosition.fk_condition(package_position)).first
                package_position=PackagePosition.new(package_position)
                package_position.save
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
            package_positions=JSON.parse(params[:package_position])
            package_positions.each do |package_position|
              if u=PackagePosition.unscoped.where(PackagePosition.fk_condition(package_position)).first
                u.update(package_position.except(PackagePosition::FK, 'id'))
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
            package_positions=JSON.parse(params[:package_position])
            package_positions.each do |package_position|
              if package_position=PackagePosition.unscoped.where(PackagePosition.fk_condition(package_position)).first
                package_position.update(is_delete: true)
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