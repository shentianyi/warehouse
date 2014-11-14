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

    # get deliveries
    # optional params: created_at, user_id, state...
    get :list do
      delivery_date = Time.parse(params[:delivery_date])
      deliveries = Delivery.where(created_at: (12.hour.ago..delivery_date.end_of_day), source_id: current_user.location_id).all.order(created_at: :desc)
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
      f=LogisticsContainer.build(params[:package_id], current_user.id, current_user.location_id)

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
      unless d = LogisticsContainer.exists?(params[:id]
        return {result: 0, content: DeliveryMessage::NotExit}
      end

      unless Forklift.where(id: params[:forklifts]).count == params[:forklifts].length
        return {result: 0, content: DeliveryMessage::ForkliftHasNotExist}
      end

      unless LogisticsContainer.are_roots?(params[:forklifts], current_user.location_id)
        return {result: 0, content: DeliveryMessage::ForkliftExistInOthers}
      end

      # if !DeliveryState.can_update?(d.state)
      #   return {result: 0, content: DeliveryMessage::CannotUpdate}
      # end

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

      # if !ForkliftState.can_update?(f.state)
      #   return {result: 0, content: ForkliftMessage::CannotUpdate}
      # end

      result =f.remove
      if result
        {result: 1, content: DeliveryMessage::DeleteForkliftSuccess}
      else
        {result: 0, content: DeliveryMessage::DeleteForkliftFailed}
      end
    end

    # fake_send

    # send delivery
    post :send do
      msg = ApiMessage.new

=begin
      unless d = Delivery.find_by_id(params[:id])
        msg.set_false(DeliveryMessage::NotExit)
        return msg.to_json
      end
=end
      unless d = Delivery.exist?(params[:id])
        return {result: 0, content: DeliveryMessage::NotExist}
      end

      #if (d = DeliveryService.exit?(params[:id])).nil?
      #  return {result:0,content:DeliveryMessage::NotExit}
      #end

      #需要活的当前Delivery对应的location container
      #然后检查Delivery以及location container的状态

      #check state if can be sent
      d.state_for("send")

=begin
      if !DeliveryState.can_update?(d.state)
        msg.set_false(DeliveryMessage::CannotUpdate)
        return msg.to_json
      end
=end


      if DeliveryService.send(d, current_user)
        if NetService.ping()
          msg.set_true(DeliveryMessage::SendSuccess)
          return msg.to_json
        else
          msg.set_true(DeliveryMessage::SendSuccess+DeliveryMessage::NetworkNotGood)
          return msg.to_json
        end

      else
        msg.set_false(DeliveryMessage::SendFailed)
        return msg.to_json
      end
    end

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
    delete do
      if (d = DeliveryService.exit?(params[:id])).nil?
        return {result: 0, content: DeliveryMessage::NotExit}
      end

      if !DeliveryState.can_delete?(d.state)
        return {result: 0, content: DeliveryMessage::CannotDelete}
      end

      if  DeliveryService.delete(d)
        {result: 1, content: DeliveryMessage::DeleteSuccess}
      else
        {result: 0, content: DeliveryMessage::DeleteFailed}
      end
    end

    # get delivery detail
    get :detail do
      if (d = DeliveryService.exit?(params[:id])).nil?
        return {result: 0, content: DeliveryMessage::NotExit}
      end
      content = DeliveryPresenter.new(d).to_json_with_forklifts(false)
      {result: 1, content: content}
    end

    put do
      if (d = DeliveryService.exit?(delivery_params[:id])).nil?
        return {result: 0, content: DeliveryMessage::NotExit}
      end

      if !DeliveryState.can_delete?(d.state)
        return {result: 0, content: DeliveryMessage::CannotUpdate}
      end

      if DeliveryService.update(d, delivery_params)
        {result: 1, content: DeliveryMessage::UpdateSuccess}
      else
        {result: 0, contnet: DeliveryMessage::UpdateFailed}
      end
    end

    # receive delivery
    post :receive do
      if (d = DeliveryService.exit?(params[:id])).nil?
        return {result: 0, content: DeliveryMessage::NotExit}
      end

      if !DeliveryState.before_state?(DeliveryState::DESTINATION, d.state)
        return {result: 0, content: DeliveryMessage::ReceiveFailed+DeliveryMessage::NotSend}
      end

      if DeliveryService.receive(d)
        {result: 1, content: DeliveryPresenter.new(d).to_json_with_forklifts(true)}
      else
        {result: 0, content: DeliveryMessage::AlreadyReceived}
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
      DeliveryPresenter.init_presenters(DeliveryService.search(arg, false)).each do |dp|
        data<<dp.to_json
      end
      {result: 1, content: data}
    end

    # confirm_receive
    post :confirm_receive do
      if (d = DeliveryService.exit?(params[:id])).nil?
        return {result: 0, content: DeliveryMessage::NotExit}
      end

      if DeliveryService.confirm_received(d, current_user)
        {result: 1, content: DeliveryMessage::ReceiveSuccess}
      else
        {result: 0, content: DeliveryMessage::ReceiveFailed}
      end

    end
  end
end
