module V1
  module Service
    class ImportServiceAPI<ServiceBase
      namespace 'import'
      guard_all!

      post :store_container do
        user=User.find('PACK_SYS_USER')

        ActiveRecord::Base.transaction do
          # build forklift
          if forklift=Forklift.exists?(params[:id])
            fsc=forklift.store_containers.first
          else
            forklift = Forklift.new(id: params[:id], user_id: user.id, location_id: user.location_id)
            if forklift.save
              fsc=forklift.store_containers.create(source_location_id: user.location_id, user_id: user.id)
            end
          end

          params[:packages].each do |p|
            if package=Package.exists?(p[:id])
              psc=package.store_containers.first
            else
              package=Package.new(id: p[:id], part_id: p[:part_id], quantity: p[:quantity], custom_fifo_time: p[:custom_fifo_time],
                                  user_id: user.id, location_id: user.location_id)
              if package.save
                psc=package.store_containers.create(source_location_id: user.location_id, user_id : user.id)
              end
            end
            if psc.root?
              psc.update_attribute :parent, nil
            end
            fsc.add(psc)
          end

        end

      end
    end
  end
end