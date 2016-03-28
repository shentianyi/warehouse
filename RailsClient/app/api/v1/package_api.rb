# -*- coding: utf-8 -*-
module V1
  class PackageAPI<Base
    namespace :packages do
      guard_all!

      #strong parameters
      helpers do
        def package_params
          ActionController::Parameters.new(params).require(:package).permit(:id, :part_id, :part_id_display, :quantity, :quantity_display,
                                                                            :custom_fifo_time, :fifo_time_display)
        end
      end

      #get package info
      get do
        if p = Package.exists?(params[:package_id])
          return {result: 0, content: "唯一码不存在!"}
        end

        args = {}
        args[:package_id] = p.id
        args[:part_id] = p.part.nr
        args[:qty] = p.quantity
        args[:fifo] =p.parsed_fifo# p.fifo_time_display.blank? ? '' : Date.strptime(p.fifo_time_display.sub(/W\s*/, ''), '%d.%m.%y')
        {result: '1', content: args}
      end

      #get package info from NStorage
      get :nstorage_package do
        return {result: 0, content: "请输入唯一码"} if params[:package_id].blank?

        params[:package_id]=params[:package_id].sub(/S|M/, '') if params[:package_id].present?
        unless storage = NStorage.exists_package?(params[:package_id])
          return {result: 0, content: "唯一码不存在!"}
        end

        args = {}
        args[:package_id] = storage.packageId
        args[:part_id] = storage.part.nr
        args[:qty] = storage.qty
        args[:whouse_id] = storage.ware_house_id
        args[:position_id] = storage.position_id
        args[:fifo] = storage.fifo.blank? ? '' : storage.fifo.localtime
        {result: '1', content: args}
      end

      #get packages by created_at time and state
      #@start_time
      #@end_time
      #@state
      #@type
      #@parent
      get :get_by_time_and_state do
        args = {}

        start_time = params[:start_time].nil? ? SysConfig.app_show_recent_data_days.to_i.days.ago : params[:start_time]
        end_time = params[:end_time].nil? ? Time.now : params[:end_time]

        args[:state] = params[:state] if params[:state]

        if params[:type].nil? || params[:type].to_i == 0
          args[:created_at] = start_time..end_time
          args[:source_location_id] = [current_user.location_id, nil]
          args[:user_id] = current_user.id if params[:all].nil?
        else
          args['records.impl_time'] = start_time..end_time
          #args['records.impl_user_type'] = ImplUserType::RECEIVER
          args[:des_location_id] = current_user.location_id
        end

       # args[:ancestry]= nil

        {result: 1, content: PackagePresenter.init_json_presenters(PackageService.search(args).order(created_at: :desc).all,current_user)}
      end

      # validate package id
      # @deprecated
      # use validate_id instead
      post :validate do
        p params
        if Package.id_valid?(params[:id])
          {result: 1, content: ''}
        else
          {result: 0, content: PackageMessage::IdNotValid}
        end
      end

      #validate package id
      get :validate_id do
        if Package.id_valid?(params[:id])
          {result: 1, content: ''}
        else
          {result: 0, content: PackageMessage::IdNotValid}
        end
      end

      #=============
      # url: POST packages/
      # params
      #=============
      post do
        m = PackageService.create package_params, current_user
        m.result ? {result: 1, content: PackagePresenter.new(m.object).to_json(current_user)} : {result: 0, content: m.content}
      end

      #=============
      # url: PUT packages/:id
      #=============
      put do
        msg = PackageService.update(package_params)
        if msg.result
          {result: 1, content: PackagePresenter.new(msg.object).to_json}
        else
          {result: 0, content: msg.content}
        end
      end

      #=============
      # url: DELETE packages/:id
      #=============
      delete do
        msg = LogisticsContainerService.destroy_by_id(params[:id])
        if msg.result
          {result: 1, content: BaseMessage::DESTROYED}
        else
          {result: 0, content: msg.content}
        end
      end


      post :check do
        msg = ApiMessage.new
        unless p = LogisticsContainer.exists?(params[:id])
          return msg.set_false(MovableMessage::TargetNotExist)
        end
        if (r = p.get_movable_service.check(p, current_user)).result
          p r
          p '---------------------------------'
          return msg.set_true(r.content)
        else
          return msg.set_false(r.content)
        end
      end

      # uncheck package
      # as reject a package
      post :uncheck do
        #msg = PackageService.uncheck(params[:id])
        msg = ApiMessage.new
        unless p = LogisticsContainer.exists?(params[:id])
          return msg.set_false(MovableMessage::TargetNotExist)
        end
        if (r = p.get_movable_service.reject(p, current_user)).result
          return msg.set_true(r.content)
        else
          return msg.set_false(r.content)
        end
      end

      post :reject do
        msg = ApiMessage.new
        unless p = LogisticsContainer.exists?(params[:id])
          return msg.set_false(MovableMessage::TargetNotExist)
        end

        if (r = p.get_movable_service.reject(p, current_user)).result
          msg.set_true(r.content)
        else
          msg.set_false(r.content)
        end
      end

      post :receive do
        msg = ApiMessage.new
        unless p = LogisticsContainer.find_latest_by_container_id(params[:id])
          return msg.set_false(MovableMessage::TargetNotExist)
        end

        unless p.root?
          return msg.set_false(PackageMessage::InForkliftCannotReceive)
        end

        if (r = PackageService.receive(p, current_user)).result
          return msg.set_true(PackagePresenter.new(p).to_json)
        else
          msg.set_false(r.content)
        end

      end

      post :send do
        msg = ApiMessage.new

        unless lc = LogisticsContainer.exists?(params[:id])
          return msg.set_false(PackageMessage::NotExit)
        end

        unless lc.can_update?
          return msg.set_false(PackageMessage::CannotUpdate)
        end

        unless destination = Location.find_by_id(params[:destination_id])
          return msg.set_false(MovableMessage::DestinationNotExist)
        end

        #发送包装箱时，需要指定目标仓库
        unless warehouse = destination.whouses.where(id: params[:whouse_id]).first
          return msg.set_false(PackageMessage::WarehouseNotInLocation)
        end

        unless (r = PackageService.dispatch(lc, destination, current_user)).result
          return msg.set_false(r.content)
        end

        lc.update(destinationable: warehouse)

        return msg.set_true(MovableMessage::Success)
      end

      #确认接收
      post :confirm_receive do
        unless lc = LogisticsContainer.exists?(params[:id])
          return {result: 0, content: DeliveryMessage::NotExit}
        end

        unless (m=lc.get_movable_service.check(lc, current_user)).result
          return m.set_false(m.content)
        end

        return {result: 1, content: DeliveryMessage::ReceiveSuccess}
      end
    end
  end
end
