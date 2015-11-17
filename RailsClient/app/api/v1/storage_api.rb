module V1
  class StorageAPI<Base
    include APIGuard
    namespace :storages do

      desc 'Stock Move.'
      params do
        # requires :fifo, type: String, desc: 'require fifo'
        requires :toWh, type: String, desc: 'require toWh(to warehouse, whId)'
        requires :toPosition, type: String, desc: 'require toPosition'
        # requires :type, type: String, desc: 'require move type'
        optional :fromWh, type: String, desc: 'require toWh(to warehouse, whId)'
        optional :fromPosition, type: String, desc: 'require toPosition'
        optional :qty, type: String, desc: 'require qty(quantity)'
        optional :partNr, type: String
        optional :uniqueId, type: String
        optional :packageId, type: String
        optional :fifo, type: String
      end
      post :move do
        params[:toWh]=params[:toWh].sub(/LO/, '')
        params[:toPosition]=params[:toPosition].sub(/LO/, '')
        params[:fromWh]=params[:fromWh].sub(/LO/, '') if params[:fromWh].present?
        params[:fromPosition]=params[:fromPosition].sub(/LO/, '') if params[:fromPosition].present?

        params[:partNr]=params[:partNr].sub(/P/, '') if params[:partNr].present?
        params[:user] = current_user
        puts "#{params.to_json}-----------"
        begin
          params[:qty]=params[:qty].sub(/Q/, '').to_f if params[:qty].present?
          if params[:partNr].present?
            raise '请填写数量' unless params[:qty].present?
            params[:packageId]=nil
          end
          msg = FileHandler::Excel::NStorageHandler.validate_move_row params
          unless msg.result
            return {result: 0, content: msg.content}
          end

          NStorage.transaction do
            WhouseService.new.move(params)
          end
        rescue => e
          if params[:uniq].blank?
            return {result: 0, content: e.message}
          else
            raise e.message
          end
        end
        {result: 1, content: '移库成功'}
      end


      post :move_store do
        ActiveRecord::Base.transaction do
          if forklift=Forklift.exists?(params[:id])
            #该Forklift是否已经入库？
            if fsc=forklift.store_containers.where(source_location_id: current_user.location_id).first
              fsc_destination=nil
              fsc.descendants.joins(:package).each do |psc|
                destination=psc.destinationable
                psc.move_store(destination) if psc.can_move_store?(destination)
                fsc_destination=destination
              end
              if fsc.can_move_store?(fsc_destination)
                fsc.move_store(fsc_destination)
                return {result: 1, content: '移库成功！'}
              else
                return {result: 0, content: '还未入库！'}
              end
            else
              return {result: 0, content: ForkliftMessage::NotExit}
            end
          end
        end
      end

      #以包装箱为单位进行移库
      post :move_storage do

      end

      #以包装箱为单位创建Storage
      post :create_storage do

      end

      #以包装箱为党委删除Storage
      post :destroy_storage do

      end
    end
  end
end
