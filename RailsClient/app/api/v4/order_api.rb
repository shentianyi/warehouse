module V4
class OrderAPI < Base
  token_guard_all!

    namespace :orders do
      params do
        requires :order_car_id, type: String, desc: 'order car id'
        requires :order_box_ids, type: Array, desc: 'order box ids'
      end
      post :create_by_car do
        ## TODO not in use, replaced by /picks/create_by_car
        OrderService.create_by_car(current_user, params)
      end

      params do
        requires :ip, type: String, desc: 'modem ip'
        requires :led_id, type: String, desc: 'led id'
        requires :qty, type: Integer, desc: 'order qty'
      end
      post :create_by_led do
        OrderService.create_by_led(current_user, params)
      end
    end
  end
end