module V3
  class PickItemApi<Base
    guard_all!

    namespace :pick_items do

      params do
        requires :id, type: String, desc: 'Pick Item ID'
      end
      get :pick_info do
        PickItemService.pick_info(params[:id], current_user)
      end

    end
  end
end