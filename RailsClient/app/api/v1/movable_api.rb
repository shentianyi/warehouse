
module V1
  class MovableAPI<Base
    namespace :movables
    gurad_all!

    #
    helpers do
      def movable_params
        ActionController::Parameters.new(params).require(:movable).permit(:id)
      end
    end

    post :dispatch do
      msg = ApiMessage.new
      lc = LogisticsContainer.where({id:params[:id]}).first
      unless lc
        return msg.set_false(MovableMessage::TargetNotExst).to_json
      end

      destination = LocationService.search({id:params[:destination_id]})

      unless destination

        return msg.set_false(MovableMessage::DestinationNotExist).to_json
      end

      unless LogisticsContainerService.dispatch(lc,destination,current_user)
        return msg.set_false(MovableMessage::DispatchFailed).to_json
      end
      msg.set_true(MovableMessage::Success).to_json
    end

    post :receive do
      msg = ApiMessage.new
      lc = LogisticsContainer.where({id:params[:id]}).first

      unless lc
        return msg.set_false(MovableMessage::TargetNotExst).to_json
      end

      unless LogisticsContainerService.receive(lc,current_user)
        return msg.set_false(MovableMessage::ReceiveFailed).to_json
      end

      return msg.set_true(MovableMessage::Success).to_json
    end

    post :check do
      lc = LogisticsContainer.where({id:params[:id]}).first

      unless lc
        return msg.set_false(MovableMessage::TargetNotExst).to_json
      end

      unless LogisticsContainerService.check(lc,current_user)
        return msg.set_false(MovableMessage::CheckFailed).to_json
      end

      return msg.set_true(MovableMessage::Success).to_json
    end

    post :reject do
      lc = LogisticsContainer.where({id:params[:id]}).first

      unless lc
        return msg.set_false(MovableMessage::TargetNotExst).to_json
      end

      unless LogisticsContainerService.reject(lc,current_user)
        return msg.set_false(MovableMessage::RejectFailed).to_json
      end

      return msg.set_true(MovableMessage::Success).to_json
    end
  end
end