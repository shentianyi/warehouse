module V1
  class LedAPI<Base
    namespace :leds
    guard_all!
    helpers do
      def order_params
        ActionController::Parameters.new(params).require(:order).permit(:id, :current_state)
      end
    end

    # params[:position]
    # params[:state]
    post :reset do
      msg=LedService.update_led_state_by_position(params[:position], params[:state])
      msg.result = msg.result ? 1 : 0
      return msg
    end

    # params[:whouse,:part_id]
    get :position_state do
      pp = OrderItemService.verify_department(params[:whouse],params[:part_id])
      if pp.nil?
        return {result:0,content:'库位或零件不存在'}
      end
      led = Led.find_by_position(pp.position.detail)
      if led.nil?
        return {result:0,content:'LED灯未找到'}
      end
      ls = LedState.find_by_state(led.current_state)
      if ls.nil?
        return {result:0,content:'LED灯状态错误,请重置'}
      end

      {result:1,content:{position:pp.position.detail,state:led.current_state}}
    end

    get :led_state_list do
      list = []
      LedState.all.order(:state).each do |ls|
        list << {state:ls.state,R:ls.R,G:ls.G,B:ls.B}
      end
      {result:1,content:list}
    end
  end
end
