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
      deliveries = Delivery.where(created_at: (delivery_date.beginning_of_day..delivery_date.end_of_day)).all.order(:created_at).order(created_at: :desc)
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
        {result:0,content:'托清单不存在或已被加入其他运单中!'}
      end
    end

    # add forklift
    # id: delivery id
    # forklift: forklift ids
    post :add_forklift do
      if (d = DeliveryService.exit?(params[:id])).nil?
        return {result:0,content:'运单不存在!'}
      end

      if !DeliveryState.can_update?(d.state)
        return {result:0,content:'运单不能修改'}
      end

      if DeliveryService.add_forklifts(d,params[:forklifts])
        {result:1,content:'添加清单成功'}
      else
        {result:0,content:''}
      end

    end

    # remove forklift
    # id is forklift_id
    delete :remove_forklift do
      if (f = ForkliftService.exits?(params[:forklift_id])).nil?
        return {result:0,content:'清单不存在!'}
      end
      if !ForkliftState.can_update?(f.state)
        return {result:0,content:'清单不能修改!'}
      end

      result = DeliveryService.remove_forklifk(f)
      if result
        {result:1,content:'删除清单成功'}
      else
        {result:0,content:'清楚清单失败'}
      end
    end

    # send delivery
    post :send do
      if (d = DeliveryService.exit?(params[:id])).nil?
        return {result:0,content:'运单不存在!'}
      end
      if !DeliveryState.can_update?(d.state)
        return {result:0,content:'运单不能修改'}
      end
      if DeliveryService.send(d,current_user)
        if NetService.ping()
          {result:1,content:'发送成功'}
        else
          {result:0,content:'发送成功，但是网络不通畅，无法同步，请导出运单！'}
        end

      else
        {result:0,content:'发送失败!'}
      end
    end

    post do
      d = Delivery.new(delivery_params)
      d.user = current_user
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
        return {result:0,content:'运单不存在!'}
      end

      if !DeliveryState.can_delete?(d.state)
        return {result:0,content:'运单不能删除'}
      end

      if  DeliveryService.delete(d)
        {result:1,content:'删除成功'}
      else
        {result:0,content:'删除失败'}
      end

    end

    # get delivery detail
    get :detail do
      if (d = DeliveryService.exit?(params[:id])).nil?
        return {result:0,content:'运单不存在!'}
      end
      content = DeliveryPresenter.new(d).to_json_with_forklifts(false)
      puts content
      {result:1,content:content}
    end

    put do
      if (d = DeliveryService.exit?(delivery_params[:id])).nil?
        return {result:0,content:'运单不存在!'}
      end

      if !DeliveryState.can_delete?(d.state)
        return {result:0,content:'运单不能修改'}
      end

      if DeliveryService.update(d,delivery_params)
        {result:1,content:'修改成功'}
      else
        {result:0,contnet:'修改失败'}
      end
    end

    # receive delivery
    post :receive do
      if (d = DeliveryService.exit?(params[:id])).nil?
        return {result:0,content:'运单不存在!'}
      end

      if DeliveryService.receive(d)
        {result:1,content:DeliveryPresenter.new(d).to_json_with_forklifts(true)}
      else
        {result:0,content:'运单已接收!'}
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
        return {result:0,content:'运单不存在!'}
      end

      if DeliveryService.confirm_received(d,current_user)
        {result:1,content:'接收成功！'}
      else
        {result:0,content:'接收失败!'}
      end

    end
  end
end
