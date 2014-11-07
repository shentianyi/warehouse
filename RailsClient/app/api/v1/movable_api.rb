module V1
  class MovableAPI<Base
    namespace :movable
    guard_all!

    #strong parameters
    helpers do
      def movable_params
        ActionController::Parameters.new(params).require(:movable).permit(:id,:sender_id,:receiver_id,:delivery_date,:state,:received_date)
      end
    end

    post :send do
      msg = ApiMessage.new

      unless lc = LocationContainer.find_by_id(params[:id])
        return msg.set_false("不发送!").to_json
      end

      unless LocationContainerService.before_send(lc)
        return msg.set_false("发送条件检查失败，无法发送").to_json
      end
    end
  end
end