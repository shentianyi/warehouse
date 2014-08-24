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
  end
end
