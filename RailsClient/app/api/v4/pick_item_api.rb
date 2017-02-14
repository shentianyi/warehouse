module V4
  class PickItemAPI<Base
    token_guard_all!

    namespace :pick_items do


      params do
        requires :car_nr, type: String, desc: 'Car Nr'
      end
      get :by_car_nr do
        PickItemService.by_car_nr(params[:car_nr])
      end

      params do
        requires :id, type: String, desc: 'Pick Item ID'
      end
      get :pick_info do
        PickItemService.pick_info(params[:id], current_user)
      end

    end
  end
end