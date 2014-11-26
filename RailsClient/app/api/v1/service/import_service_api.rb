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
          if forklift=Forklift.exists?(data['id'])
            fsc=forklift.store_containers.where(location_id: user.location_id).first
          else
            forklift = Forklift.new(id: data['id'], user_id: user.id, location_id: user.location_id)
            if forklift.save
              fsc=forklift.store_containers.create(source_location_id: user.location_id, user_id: user.id)
            end
          end

          data['packages'].each do |p|
            if package=Package.exists?(p['id'])
              psc=package.store_containers.where(location_id: user.location_id).first
            else
              package=Package.new(id: p['id'], part_id: p['part_id'], quantity: p['quantity'], fifo_time: p['fifo_time'],
                                  user_id: user.id, location_id: user.location_id)
              psc=package.store_containers.build(source_location_id: user.location_id, user_id: user.id, destinationable_id: p['project'], destinationable_type: 'Whouse')
              psc.in_store(whouse)
              package.save
              psc.save
            end
            unless psc.root?
              psc.update_attribute :parent, nil
            end
            fsc.add(psc)
          end

        end
        {Result: true, Code: 1, Content: 'Success'}
      end

      post :unstore_container do
        if forklift=Forklift.exists?(data['id'])
          fsc=forklift.store_containers.where(location_id: user.location_id).first
          fsc.descendants.join(:packages).where(packages: {current_positionable_id: data['whouse'], current_positionable_type: 'Whouse'}).all.each do |psc|
            psc.cancel_store
            psc.destroy
          end
        end
      end
    end
  end
end
