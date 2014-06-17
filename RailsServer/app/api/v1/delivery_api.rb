
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
      deliveries = DeliveryService.search(params.permit(:id,:delivery_date,:user_id,:destination_id))
      data = []
      DeliveryPresenter.init_presenters(deliveries).each do |d|
        data << d.to_json
      end
      {result:true,content:data}
    end

    # check forklift
    # forklift id
    post :check_forklift do
      #d = Delivery.find_by_id(params[:id])
      f = Forklift.find_by_id(params[:forklift_id])
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
      result = DeliveryService.add_forklifts(params[:id],params[:forklifts])
      {result:result,content:''}
    end

    # remove package
    # id is forklift_id
    delete :remove_forklift do
      result = DeliveryService.remove_forklifk(params[:forklift_id])
      {result:result,content:''}
    end

    # send delivery
    post :send do
      d =Delivery.find_by_id(params[:id])
      if d
        d.state = DeliveryState::WAY
        result = d.save == true ? 1:0
      else
        result = 0
      end
      {result:result,content:''}
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
      result = DeliveryService.delete(params[:id])
      {result:result,content:''}
    end

    # get delivery detail
    get :detail do
      d = Delivery.find_by_id(params[:id])
      data = []
      if d
        {result:1,content:DeliveryPresenter.new(d).to_json_with_forklifts(false)}
      else
        {result:0,content:'运单未找到!'}
      end

    end

    put do
      d = DeliveryService.update(delivery_params)
      if d
        {result:1,content:''}
      else
        {result:0,contnet:''}
      end
    end

    # receive delivery
    post :receive do
      d = Delivery.find_by_id(params[:id])
      if d
        #d.received_date = Time.now
        #d.receiver = current_user
        d.state = DeliveryState::DESTINATION
        result = d.save == true ? 1:0

        {result:1,content:DeliveryPresenter.new(d).to_json_with_forklifts(true)}
      else
        result = 0
        {result:result,content:''}
      end

    end

    # received deliveries
    get :received do
      arg={
            state: DeliveryState::RECEIVED,
            received_date: params[:received_date]
      }
      arg[:user_id]=params[:user_id] unless params[:user_id].blank?

      DeliveryService.search(arg)
    end

    # confirm_receive
    post :confirm_receive do
      d = Delivery.find_by_id(params[:id])
      if d
        d.receiver = current_user
        d.received_date = Time.now
        d.state = DeliveryState::RECEIVED
        if d.save
          {
              result:1,content:''
          }
        else
          {
              result:0,content:'接收失败!'
          }
        end
      else
        {result:0,content:'运单未找到!'}
      end
    end
  end
end