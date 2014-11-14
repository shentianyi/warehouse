
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
      lc = LogisticsContainer.where({id:params[:id]}).first
      unless lc

      end

      unless lc.state_for("dispatch")

      end

      destination = LocationService.search({id:params[:destination_id]})

      unless destination

      end

      LogisticsContainerService.dispatch(lc,destination,current_user)
      {result:1,content:"SUCCESS"}
    end

    post :receive do
      lc = LogisticsContainer.where({id:params[:id]}).first

      unless lc

      end

      unless lc.state_fro("receive")

      end

      LogisticsContainerService.receive(lc,current_user)

      {result:1,content:"SUCCESS"}
    end

    post :check do
      lc = LogisticsContainer.where({id:params[:id]}).first

      unless lc

      end

      unless lc.state_fro("check")

      end

      LogisticsContainerService.check(lc,current_user)

      {result:1,content:"SUCCESS"}
    end

    post :reject do
      lc = LogisticsContainer.where({id:params[:id]}).first

      unless lc

      end

      unless lc.state_fro("reject")

      end

      LogisticsContainerService.reject(lc,current_user)

      {result:1,content:"SUCCESS"}
    end
  end
end