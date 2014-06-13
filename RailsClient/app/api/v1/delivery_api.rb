module V1
  class DeliveryAPI<Base
    namespace :deliveries
    guard_all!

    # get deliveries
    # optional params: created_at, user_id, state...
    get :list do

    end

    # check forklift
    # forklift id
    post :check_forklift do

    end

    # add forklift
    # id: delivery id
    # forklift: forklift ids
    post :add_forklift do

    end

    # remove package
    # id is forklift_id
    delete :remove_forklift do

    end

    # send delivery
    post :send do

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

    end
  end
end