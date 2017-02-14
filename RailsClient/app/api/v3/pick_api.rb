module V3
  class PickApi< Base
    guard_all!

    namespace :picks do
      get :undone_list do
        PickListService.by_status([PickStatus::INIT, PickStatus::PICKING])
      end

      params do
        requires :id, type: String, desc: 'Pick List ID'
      end
      get :pick_items do
        PickListService.pick_items(params[:id])
      end

      params do
        requires :id, type: String, desc: 'Pick List ID'
        requires :items, type: Array, desc: 'Pick Item infos'
      end
      post :do_pick do
        PickListService.do_pick(params, current_user)
      end

    end
  end
end