# -*- coding: utf-8 -*-

module V1
  class DeliveryAPI<Base
    namespace :deliveries
    guard_all!

    #strong parameters
    helpers do
      def delivery_params
        ActionController::Parameters.new(params).require(:delivery).permit(:id, :destination_id, :user_id, :delivery_date, :forklifts, :remark)
      end
    end

    # list
    # @params: delivery_date
    # *get all deliveries sent from current_user's location*
    get :list do
      created_at = Time.parse(params[:delivery_date])
      args = {
          created_at: (12.hour.ago..created_at.end_of_day),
          source_location_id: current_user.location_id
      }
      deliveries = LogisticsContainerService.find_by_container_type(ContainerType::DELIVERY,args).all.order(created_at: :desc)
      #Delivery.where(created_at: (12.hour.ago..delivery_date.end_of_day), source_id: current_user.location_id).all.order(created_at: :desc)
      data = []
      DeliveryPresenter.init_presenters(deliveries).each do |d|
        data << d.to_json
      end
      #puts data
      {result: 1, content: data}
    end

    # check forklift
    # forklift id
    post :check_forklift do
      unless Forklift.exists?(params[:forklift_id])
        return {result: 0, content: DeliveryMessage::CheckForkliftFailed}
      end

      lc = LogisticsContainer.find_latest_by_container_id(params[:forklift_id])
      unless lc.can_copy?
        return {resule: 0, content: ForkliftMessage::CheckForkliftFailed}
      end

      f=LogisticsContainer.build(params[:forklift_id], current_user.id, current_user.location_id)

      if f.root?
        {result: 1, content: ForkliftPresenter.new(f).to_json}
      else
        {result: 0, content: DeliveryMessage::CheckForkliftFailed}
      end
    end

    # add forklift
    # id: delivery id
    # forklift: forklift ids
    post :add_forklift do
      unless d = LogisticsContainer.exists?(params[:id])
        return {result: 0, content: DeliveryMessage::NotExit}
      end

      unless Forklift.where(id: params[:forklifts]).count == params[:forklifts].length
        return {result: 0, content: DeliveryMessage::ForkliftHasNotExist}
      end

      unless LogisticsContainer.are_roots?(params[:forklifts], current_user.location_id)
        return {result: 0, content: DeliveryMessage::ForkliftExistInOthers}
      end

      unless d.can_update?
        return {result: 0, content: DeliveryMessage::CannotUpdate}
      end

      if d.add_by_ids(params[:forklifts])
        {result: 1, content: DeliveryMessage::AddForkliftSuccess}
      else
        {result: 0, content: ''}
      end
    end

    # remove forklift
    # id is forklift_id
    delete :remove_forklift do
      unless f = LogisticsContainer.exists?(params[:forklift_id])
        return {result: 0, content: ForkliftMessage::NotExit}
      end

      unless f.can_delete?
        return {result: 0, content: DeliveryMessage::DeleteForkliftFailed}
      end

      result =f.remove
      if result
        {result: 1, content: DeliveryMessage::DeleteForkliftSuccess}
      else
        {result: 0, content: DeliveryMessage::DeleteForkliftFailed}
      end
    end

    # send delivery
    #**
    #@deprecated
    #**
    post :send do
      msg = ApiMessage.new

      unless lc = LogisticsContainer.exists?(params[:id])
        return msg.set_false(DeliveryMessage::NotExist).to_json
      end

      unless lc.can_update?
        return msg.set_false(DeliveryMessage::CannotUpdate).to_json
      end

      unless destination = Location.find_by_id(params[:destination_id])
        return msg.set_false(DeliveryMessage::DestinationNotExist).to_json
      end

      unless (r = LogisticsContainerService.dispatch(lc,destination,current_user)).result
        return msg.set_false(r.content).to_json
      end

      return msg.set_true(DeliveryMessage::SendSuccess).to_json
    end

    #create delivery
    #@forklifts : forklift ids
    post do
      if params[:forklifts] && params[:forklifts].length>0
        unless Forklift.where(id: params[:forklifts]).count == params[:forklifts].length
          return {result: 0, content: DeliveryMessage::ForkliftHasNotExist}
        end
        unless LogisticsContainer.are_roots?(params[:forklifts], current_user.location_id)
          return {result: 0, content: DeliveryMessage::ForkliftExistInOthers}
        end
      end

      msg = DeliveryService.create(delivery_params, current_user)

      if params.has_key?(:forklifts)
        msg.object.add_by_ids(params[:forklifts])
      end
      #
      if msg.result
        {result: 1, content: DeliveryPresenter.new(msg.object).to_json}
      else
        {result: 0, content: msg.content}
      end
    end

    # delete delivery
    #@id
    delete do
      msg = LogisticsContainerService.destroy_by_id(params[:id])
      if msg.result
        {result: 1, content: BaseMessage::DESTROYED}
      else
        {result: 0, content: msg.content}
      end
    end

    # get delivery detail
    get :detail do
      msg = Message.new
      unless lc = LogisticsContainer.exists?(params[:id])
        return msg.set_false(DeliveryMessage::NotExist).to_json
      end
      content = DeliveryPresenter.new(d).to_json
      #{result: 1, content: content}
      msg.set_true(content).to_json
    end

    # update delivery
    put do
      msg = Message.new
      args=delivery_params
      if (d = LogisticsContainer.exists?(args[:id])).nil?
        return msg.set_false(DeliveryMessage::NotExist).to_json
      end

      unless d.can_update?
        return msg.set_false(DeliveryMessage::CannotUpdate).to_json
      end

      if d.update_attributes(remark:args[:remark])
        return msg.set_true(DeliveryMessage::UpdateSuccess).to_json
      else
        return msg.set_false(DeliveryMessage::UpdateFailed).to_json
      end
    end

    #**
    #@deprecated
    #**
    # receive delivery
    post :receive do
      unless d = LogisticsContainer.exists?(params[:id])
        return {return: 0, content: DeliveryMessage::NotExist}
      end

      if (r = LogisticsContainerService.receive(d,current_user)).result
        {result: 1, content: DeliveryPresenter.new(d).to_json}
      else
        {result: 0, content: r.content}
      end
    end

    # received deliveries
    # get all received deliveries by time and location
    get :received do
      args={
          state: [MovableState::ARRIVED,MovableState::CHECKED,MovableState::REJECTED],
          created_at: params[:receive_date]
      }
      args[:des_location_id]= current_user.location_id
      data = []
      DeliveryPresenter.init_presenters(LogisticsContainerService.find_by_container_type(ContainerType::DELIVERY,args)).each do |dp|
        data<<dp.to_json
      end
      {result: 1, content: data}
    end

    #**
    #@deprecated
    #**
    # confirm_receive
    # end the process of logistics
    # 统一状态之后，原来的状态不能使用了，目前通过confirm_receive接口来统一设置状态
    # 目前这个接口不做任何事情
    # -->2014-11-19需要重新修改
    post :confirm_receive do
      unless d = LogisticsContainer.exists?(params[:id])
        return {result: 0, content: DeliveryMessage::NotExit}
      end

      #if LogisticsContainerService.end_receive(d, current_user)
      {result: 1, content: DeliveryMessage::ReceiveSuccess}
      #else

      # {result: 0, content: DeliveryMessage::ReceiveFailed}
      #end
    end
  end
end
