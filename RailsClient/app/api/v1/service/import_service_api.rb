module V1
  module Service
    class ImportServiceAPI<ServiceBase
      namespace 'import'
      guard_all!

      post :store_container do
        user=User.find('PACK_SYS_USER')

        data=JSON.parse(params[:data])
        whouse=Whouse.find_by_id(data['whouse'])

        ActiveRecord::Base.transaction do
          # build forklift
          unless forklift=Forklift.exists?(data['id'])
            forklift = Forklift.new(id: data['id'], user_id: user.id, location_id: user.location_id)
            forklift.save
          end

          unless fsc=forklift.store_containers.where(source_location_id: user.location_id).first
            fsc=forklift.store_containers.create(source_location_id: user.location_id, user_id: user.id)
            fsc.save
          end

          fsc.in_store(whouse)

          data['packages'].each do |p|
            unless package=Package.exists?(p['id'])
              package=Package.new(id: p['id'], part_id: p['part_id'], quantity: p['quantity'], fifo_time: p['fifo_time'],
                                  user_id: user.id, location_id: user.location_id)
              package.save
            end
            unless psc=package.store_containers.where(source_location_id: user.location_id).first
              psc=package.store_containers.build(source_location_id: user.location_id, user_id: user.id, destinationable_id: p['project'], destinationable_type: 'Whouse')
              psc.save
            end
            psc.in_store(whouse)
            unless psc.root?
              psc.update_attribute :parent, nil
            end
            fsc.add(psc)
          end

        end
        {Result: true, Code: 1, Content: 'Success'}
      end

      post :unstore_container do
        ActiveRecord::Base.transaction do
          user=User.find('PACK_SYS_USER')
          if forklift=Forklift.exists?(params[:id])
            fsc=forklift.store_containers.where(source_location_id: user.location_id).first
            fsc.descendants.joins(:package).where(containers: {current_positionable_id: params[:whouse], current_positionable_type: 'Whouse'}).each do |psc|
              psc.cancel_store
              psc.destroy
            end
            fsc.cancel_store
            fsc.destroy
          end
        end
        {Result: true, Code: 1, Content: 'Success'}
      end
    end
  end
end
