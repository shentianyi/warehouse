module V4
  class PickAPI < Base
    token_guard_all!

    namespace :picks do
      params do
        requires :order_car_id, type: Integer, desc: 'order car id'
        optional :order_box_ids, type: String, desc: 'order box ids'
      end
      post :create_by_car do
        Rails.logger.debug '-----------------------'
        Rails.logger.debug params[:order_box_ids]
        Rails.logger.debug '-----------------------'
        params[:order_box_ids]=params[:order_box_ids].split(',')
        PickListService.create_by_car(current_user, params)
      end

      params do
        requires :status, type: Integer, desc: 'Pick Status'
      end
      get :by_status do
        PickListService.by_status(status)
      end

      get :undone_list do
        PickListService.by_status([PickStatus::INIT, PickStatus::PICKING])
      end

      params do
        requires :id, type: String, desc: 'Pick List ID'
      end
      get :pick_items do
        PickListService.pick_items(params[:id])
      end

    end
  end
end