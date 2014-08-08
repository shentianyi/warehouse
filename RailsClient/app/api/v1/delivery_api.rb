# -*- coding: utf-8 -*-

module V1
  class DeliveryAPI<Base
    namespace :deliveries
    guard_all!

    #strong parameters
    helpers do
      def delivery_params
        ActionController::Parameters.new(params).require(:delivery).permit(:id,:destination_id,:user_id,:delivery_date,:forklifts,:remark)
      end
    end

    # get deliveries
    # optional params: created_at, user_id, state...
    get :list do
      delivery_date = Time.parse(params[:delivery_date])
      deliveries = Delivery.where(created_at: (12.hour.ago..delivery_date.end_of_day)).all.order(created_at: :desc)
      data = []
      DeliveryPresenter.init_presenters(deliveries).each do |d|
        data << d.to_json
      end
      #puts data
      {result:true,content:data}
    end

    # check forklift
    # forklift id
    post :check_forklift do
      #d = Delivery.find_by_id(params[:id])
      f = ForkliftService.exits?(params[:forklift_id])
      #puts f.to_json
      if f && f.delivery.nil?
        {result:1,content:ForkliftPresenter.new(f).to_json}
      else
        {result:0,content:DeliveryMessage::CheckForkliftFailed}
      end
    end

    # add forklift
    # id: delivery id
    # forklift: forklift ids
    post :add_forklift do
      if (d = DeliveryService.exit?(params[:id])).nil?
        return {result:0,content:DeliveryMessage::NotExit}
      end

      if !DeliveryState.can_update?(d.state)
        return {result:0,content:DeliveryMessage::CannotUpdate}
      end

      if DeliveryService.add_forklifts(d,params[:forklifts])
        {result:1,content:DeliveryMessage::AddForkliftSuccess}
      else
        {result:0,content:''}
      end

    end

    # remove forklift
    # id is forklift_id
    delete :remove_forklift do
      if (f = ForkliftService.exits?(params[:forklift_id])).nil?
        return {result:0,content:ForkliftMessage::NotExit}
      end
      if !ForkliftState.can_update?(f.state)
        return {result:0,content:ForkliftMessage::CannotUpdate}
      end

      result = DeliveryService.remove_forklifk(f)
      if result
        {result:1,content:DeliveryMessage::DeleteForkliftSuccess}
      else
        {result:0,content:DeliveryMessage::DeleteForkliftFailed}
      end
    end

    # send delivery
    post :send do
      if (d = DeliveryService.exit?(params[:id])).nil?
        return {result:0,content:DeliveryMessage::NotExit}
      end
      if !DeliveryState.can_update?(d.state)
        return {result:0,content:DeliveryMessage::CannotUpdate}
      end
      if DeliveryService.send(d,current_user)
        if NetService.ping()
          {result:1,content:DeliveryMessage::SendSuccess}
        else
          {result:1,content:DeliveryMessage::SendSuccess+DeliveryMessage::NetworkNotGood}
        end

      else
        {result:0,content:DeliveryMessage::SendFailed}
      end
    end

    post do
      if DeliveryService.check_add_forklifts(params[:forklift_ids])
        return {result:0,content:DeliveryMessage::ForkliftExistInOthers}
      end

      d = Delivery.new(delivery_params)
      d.user = current_user

      d.source = current_user.location
      d.destination = current_user.location.destination

      result = d.save

      if params.has_key?(:forklifts)
        DeliveryService.add_forklifts(d,params[:forklifts])
      end

      if result
        {result:1,content:DeliveryPresenter.new(d).to_json}
      else
        {result:0,content:d.errors}
      end

    end

    # delete delivery
    delete do
      if (d = DeliveryService.exit?(params[:id])).nil?
        return {result:0,content:DeliveryMessage::NotExit}
      end

      if !DeliveryState.can_delete?(d.state)
        return {result:0,content:DeliveryMessage::CannotDelete}
      end

      if  DeliveryService.delete(d)
        {result:1,content:DeliveryMessage::DeleteSuccess}
      else
        {result:0,content:DeliveryMessage::DeleteFailed}
      end
    end

    # get delivery detail
    get :detail do
      if (d = DeliveryService.exit?(params[:id])).nil?
        return {result:0,content:DeliveryMessage::NotExit}
      end
      content = DeliveryPresenter.new(d).to_json_with_forklifts(false)
      {result:1,content:content}
    end

    put do
      if (d = DeliveryService.exit?(delivery_params[:id])).nil?
        return {result:0,content:DeliveryMessage::NotExit}
      end

      if !DeliveryState.can_delete?(d.state)
        return {result:0,content:DeliveryMessage::CannotUpdate}
      end

      if DeliveryService.update(d,delivery_params)
        {result:1,content:DeliveryMessage::UpdateSuccess}
      else
        {result:0,contnet:DeliveryMessage::UpdateFailed}
      end
    end

    # receive delivery
    post :receive do
      if (d = DeliveryService.exit?(params[:id])).nil?
        return {result:0,content:DeliveryMessage::NotExit}
      end

      if !DeliveryState.before_state?(DeliveryState::DESTINATION,d.state)
        return {result:0,content:DeliveryMessage::ReceiveFailed+DeliveryMessage::NotSend}
      end

      if DeliveryService.receive(d)
        {result:1,content:DeliveryPresenter.new(d).to_json_with_forklifts(true)}
      else
        {result:0,content:DeliveryMessage::AlreadyReceived}
      end
    end

    # received deliveries
    get :received do
      arg={
            state: DeliveryState::RECEIVED,
            received_date: params[:receive_date]
      }
      arg[:user_id]=params[:user_id] unless params[:user_id].blank?
      data = []
      DeliveryPresenter.init_presenters(DeliveryService.search(arg,false)).each do |dp|
        data<<dp.to_json
      end
      {result:1,content:data}
    end

    # confirm_receive
    post :confirm_receive do
      if (d = DeliveryService.exit?(params[:id])).nil?
        return {result:0,content:DeliveryMessage::NotExit}
      end

      if DeliveryService.confirm_received(d,current_user)
        {result:1,content:DeliveryMessage::ReceiveSuccess}
      else
        {result:0,content:DeliveryMessage::ReceiveFailed}
      end

    end
  end
end
