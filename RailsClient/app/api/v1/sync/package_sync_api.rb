module V1
  module Sync
    class PackageSyncAPI<SyncBase
      namespace 'packages'

      get do
        Package.unscoped.where('updated_at>=?', params[:last_time]).all
      end

      post do
        packages=JSON.parse(params[:package])
        packages.each do |package|
          package=Package.new(package)
          puts package
          package.save
        end
      end

      put '/:id' do
        packages=JSON.parse(params[:package])
        packages.each do |package|
          if u=Package.unscoped.find_by_id(package['id'])
            u.update(package.except('id'))
          end
        end
      end

      post :delete do
        packages=JSON.parse(params[:package])
        packages.each do |id|
          if package=Package.unscoped.find_by_id(id)
            package.update(is_delete: true)
          end
        end
      end
    end
  end
end