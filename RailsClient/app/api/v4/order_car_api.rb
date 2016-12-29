module V4
  class OrderCarAPI < Base
    token_guard_all!

    namespace :order_cars do
      params do
        requires :nr, type: String, desc: 'order car nr'
      end
      get :by_nr do
        OrderCarService.details(params[:nr])
      end

      params do
        requires :nr, type: String, desc: 'order car nr'
        requires :led_id, type: String, desc: 'led id'
        requires :order_box_nr, type: String, desc: 'order box nr'
      end
      post :bind_led_box do
        OrderCarService.bind_led_box(params)
      end


    end
  end
end