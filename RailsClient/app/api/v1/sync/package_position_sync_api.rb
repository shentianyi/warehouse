module V1
  module Sync
    class PackagePositionSyncAPI<SyncBase
      namespace 'package_positions'

      get do
        PackagePosition.unscoped.where('updated_at>=?', params[:last_time]).all
      end

      post do
        package_positions=JSON.parse(params[:package_position])
        package_positions.each do |package_position|
          package_position=PackagePosition.new(package_position)
          puts package_position
          package_position.save
        end
      end

      put '/:id' do
        package_positions=JSON.parse(params[:package_position])
        package_positions.each do |package_position|
          if u=PackagePosition.unscoped.where(PackagePosition.fk_condition(package_position)).first
            u.update(package_position.except(PackagePosition::FK,'id'))
          end
        end
      end

      post :delete do
        package_positions=JSON.parse(params[:package_position])
        package_positions.each do |id|
          if package_position=PackagePosition.unscoped.where(PackagePosition.fk_condition(package_position)).first
            package_position.update(is_delete: true)
          end
        end
      end
    end
  end
end