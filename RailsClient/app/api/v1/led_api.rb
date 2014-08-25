module V1
  class LedAPI<Base
    namespace :leds
    guard_all!
    helpers do
      def order_params
        ActionController::Parameters.new(params).require(:order).permit(:id, :current_state)
      end
    end

    # params[:position_detail]
    # params[:state]
    post :reset do
      msg=LedService.update_led_state_by_position(params[:position_detail], params[:state])
      msg.result = msg.result ? 1 : 0
      return msg
    end

    # params[:whouse,:part_id]
    get :led_state do
      pp = OrderItemService.verify_department(params[:whouse],params[:part_id])
      if pp.nil?
        {result:0,content:'库位不存在'}
      end
      led = Led.find_by_position(pp.position.detail)
      if led.nil?
        {result:0,content:'LED灯未找到'}
      end

      ls = LedState.find_by_state(led.current_state)
      if ls.nil?
        {result:0,content:'LED灯状态错误,请重置'}
      end

      {result:1,content:{position:pp.position.detail,rgb:ls.rgb,state:led.current_state}}
    end
  end
end
