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

    end

    # get delivery detail
    get :detail do

    end

    # receive delivery
    post :receive do

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