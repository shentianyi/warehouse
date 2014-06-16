module V1
  class DeliveryAPI<Base
    namespace :deliveries
    guard_all!

    #strong parameters
    helpers do
      def delivery_params
        ActionController::Parameters.new(params).require(:delivery).permit(:destination_id,:user_id,:delivery_date,:forklifts)
      end
    end

    # get deliveries
    # optional params: created_at, user_id, state...
    get :list do
      deliveries = DeliveryService.search(params)

    end

    # check forklift
    # forklift id
    post :check_forklift do
      f = Forklift.find_by_id(params[:id])
      if f.delivery.nil?
        {result:true,content:{id:f.id,created_at:f.created_at,user_id:f.stocker_id,whouse_id:f.whouse_id}}
      else
        {result:false,content:''}
      end
    end

    # add forklift
    # id: delivery id
    # forklift: forklift ids
    post :add_forklift do
      result = DeliveryService.add_forklift(params[:id],params[:forklift_id])
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
        result = d.save
      else
        result = false
      end
      {result:result,content:''}
    end

    post do
      d = Delivery.new(params.except(:forklifts))
      d.user = current_user
      params[:delivery][:forklifts].each do |forklift_id|
        f = Forklift.find_by_id(forklift_id)
        if f
          d.forklifts << f
        end
      end
      result = d.save
      if result
        content = {id:d.id,delivery_date:d.delivery_date,user_id:d.user_id}
      else
      end
      {result:result,content:''}
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
        d.forklifts.each do |f|
          data << {id:f.id,created_at:f.created_at,user_id:f.user_id,whouse_id:f.whouse_id,sum_packages:f.sum_packages,accepted_packages:f.accepted_packages}
        end
        {result:true,content:{id:d.id,user_id:d.user_id,destination_id:d.destination_id,forklifts:data}}
      else
        {result:falsen,content:'运单未找到!'}
      end

    end

    # receive delivery
    post :receive do
      d = Delivery.find_by_id(params[:id])
      if d
        d.state = DeliveryState::RECEIVED
        result = d.save
      else
        result = false
      end
      {result:result,content:''}
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
  end
end