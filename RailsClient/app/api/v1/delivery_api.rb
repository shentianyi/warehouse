
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
      deliveries = DeliveryService.search(params.permit(:id,:delivery_date,:user_id,:destination_id),true)
      data = []
      DeliveryPresenter.init_presenters(deliveries).each do |d|
        data << d.to_json
      end
      puts data
      {result:true,content:data}
    end

    # check forklift
    # forklift id
    post :check_forklift do
      #d = Delivery.find_by_id(params[:id])
      f = ForkliftService.exits?(params[:forklift_id])
      if f && f.delivery.nil?
        {result:1,content:ForkliftPresenter.new(f).to_json}
      else
        {result:0,content:''}
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
        {result:1,content:''}
      else
        {result:0,content:''}
      end

    end

    # remove package
    # id is forklift_id
    delete :remove_forklift do
      if (f = ForkliftService.exits?(params[:forklift_id])).nil?
        return {result:0,content:'清单不存在!'}
      end
      if !ForkliftState.can_update?(f.state)
        return {result:0,content:'清单不能修改!'}
      end

      result = DeliveryService.remove_forklifk(f)
      {result:result,content:''}
    end

    # send delivery
    post :send do
      if (d = DeliveryService.exit?(params[:id])).nil?
        return {result:0,content:'运单不存在!'}
      end
      if !DeliveryState.can_update?(d.state)
        return {result:0,content:'运单不能修改'}
      end
      if DeliveryService.send(d)
        {result:1,content:''}
      else
        {result:0,content:''}
      end
    end

    post do
      d = Delivery.new(delivery_params)
      d.user = current_user
      if params.has_key?(:forklifts)
        params[:forklifts].each do |forklift_id|
          f = Forklift.find_by_id(forklift_id)
          if f
            d.forklifts << f
          end
        end
      end

      result = d.save == true ? 1:0
      if result
        {result:result,content:DeliveryPresenter.new(d).to_json}
      else
        {result:result,content:d.errors}
      end

    end

    # delete delivery
    delete do
      if (d = DeliveryService.exit?(params[:id])).nil?
        return {result:0,content:'运单不存在!'}
      end

      if !DeliveryState.can_delete?(d.state)
        return {result:0,content:'运单不能修改'}
      end

      if  DeliveryService.delete(params[:id])
        {result:1,content:''}
      else
        {result:0,content:''}
      end

    end

    # get delivery detail
    get :detail do
      if (d = DeliveryService.exit?(params[:id])).nil?
        return {result:0,content:'运单不存在!'}
      end
      {result:1,content:DeliveryPresenter.new(d).to_json_with_forklifts(false)}
    end

    put do
      if (d = DeliveryService.exit?(delivery_params[:id])).nil?
        return {result:0,content:'运单不存在!'}
      end

      if !DeliveryState.can_delete?(d.state)
        return {result:0,content:'运单不能修改'}
      end

      if DeliveryService.update(d,delivery_params)
        {result:1,content:''}
      else
        {result:0,contnet:''}
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
        {result:0,content:''}
      end
    end

    # received deliveries
    get :received do
      arg={
            state: DeliveryState::DESTINATION,
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

      if DeliveryService.confirm_received(d)
        {result:1,content:''}
      else
        {result:0,content:'接收失败!'}
      end

    end
  end
end