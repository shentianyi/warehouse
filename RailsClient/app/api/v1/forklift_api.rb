module V1
  class ForkliftAPI<Base
    namespace :forklifts
    guard_all!

    #strong parameters
    helpers do
      def forklift_params
        ActionController::Parameters.new(params).require(:forklift).permit(:whouse_id,:user_id)
      end
    end

    # get binded but not add to delivery forklifts
    get :binds do
      forklifts = ForkliftService.avaliable_to_bind
      data = []
      forklifts.all.each do |f|
        data<<{id:f.id,created_at:f.created_at,user_id:f.user_id,whouse_id:f.whouse_id}
      end
      data
    end

    # create forklift
    post do
      forklift = {}
      forklift[:whouse_id] = params[:forklift][:whouse_id]
      forklift[:stocker_id] =params[:forklift][:user_id]
      f = Forklift.new(forklift)
      f.user = current_user
      result = f.save
      if result
        {result:result,content:{id:f.id,whouse_id:f.whouse_id,created_at:f.created_at,user_id:f.stocker_id}}
      else
        {result:result,content:f.errors.full_messages}
      end
    end


    # check package
    post :check_package do

    end

    # add package
    post :add_package do

    end

    # remove package
    # id is forklift_item_id
    delete :remove_package do
      result = ForkliftService.remove_package(params[:package_id])
      {result:result,content:''}
    end

    #delete forklift
    delete do
      result = ForkliftService.delete(params[:id])
      {result:result,content:''}
    end

    # get forklift detail
    get :detail do
      f = Forklift.find_by_id params[:id]
      packages = []
      if f
        f.packages.all.each do |p|
          data << {id:p.string,quantity:p.quantity_str,part_id:p.part_id,position_nr:p.position.detail}
        end
        {result:true,content:{id:f.id,whouse_id:f.whouse_id,user_id:f.stocker_id,packages:packages}}
      else
        {reuslt:false,content:'托清单未找到!'}
      end
    end

    # update forklift
    patch do
      result = ForkliftService.update(params[:id],forklift_params)
      {result:result,content:''}
    end
  end
end