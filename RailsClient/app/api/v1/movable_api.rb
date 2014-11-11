
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
      lc = LocationContainerService.search({id:params[:id]})
      source = current_user.location
      destination = LocationService.search({id:params[:destination_id]})
      LocationContainerService.dispatch(lc,source,destination,current_user)
      {result:1,content:"SUCCESS"}
    end

    post :receive do
      lc = LocationContainerService.search({id:params[:id]})
      lc.receive(current_user.id)
      {result:1,content:"SUCCESS"}
    end

    post :check do
      lc = LocationContainer.find_by_id(params[:id])
      lc.check(current_user.id)
      {result:1,content:"SUCCESS"}
    end

    post :rejected do
      lc = LocationContainer.find_by_id(params[:id])
      lc.reject(current_user.id)
      {result:1,content:"SUCCESS"}
    end
  end
end