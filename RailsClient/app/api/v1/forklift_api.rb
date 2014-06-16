module V1
  class ForkliftAPI<Base
    namespace :forklifts
    guard_all!

    #strong parameters
    helpers do
      def forklift_params
        ActionController::Parameters.new(params).require(:forklift).permit(:whouse_id,:user_id,:remark,:stocker_id,:id)
      end
    end

    # get binded but not add to delivery forklifts
    get :binds do
      forklifts = ForkliftService.avaliable_to_bind
      data = []
      forklifts.all.each do |f|
        data<<{id:f.id,created_at:f.created_at,user_id:f.user_id,stocker_id:f.stocker_id,whouse_id:f.whouse_id}
      end
      data
    end

    # create forklift
    post do
      f = Forklift.new(forklift_params)
      if forklift_params.has_key?(:user_id)
        f.user = current_user
      end
      result = f.save
      if result
        {result:result,content:{id:f.id,whouse_id:f.whouse_id,created_at:f.created_at,user_id:f.user_id,stocker_id:f.stocker_id}}
      else
        {result:result,content:f.errors.full_messages}
      end
    end

    # check package
    post :check_package do
      f = Forklift.find_by_id(params[:forklift_id])
      p = Package.find_by_id(params[:package_id])
      if f && p && p.forklift.nil?
        p.forklift = f
        {
            result:p.save,
            content:''
        }
      else
        {result:0,content:''}
      end
    end

    # add package
    post :add_package do
      args = {
          id:params[:package_id],
          part_id:params[:part_id],
          quantity_str:params[:quantity_str],
          check_in_time:params[:check_in_time]
      }
      args[:user_id] = params[:user_id] if params[:user_id]
      p = PackageService.create(args,current_user)
      f = Forklift.find_by_id(params[:forklift_id])
      if p && f
        p.forklift = f
        f.sum_packages = f.sum_packages + 1
        if f.save && p.save
          {result:1,content:{id:p.id,quantity_str:p.quantity_str,part_id:p.part_id,user_id:p.user_id,check_in_time:p.check_in_time}}
        else
          {result:0,content:'生成Package失败'}
        end
      else
        {result:0,content:'生成Package失败'}
      end
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
          #******
          #position not set
          #******
          packages << {id:p.id,quantity_str:p.quantity_str,part_id:p.part_id,position_nr:'p.position.detail',check_in_time:p.check_in_time}
        end
        {result:1,content:{id:f.id,whouse_id:f.whouse_id,user_id:f.stocker_id,packages:packages}}
      else
        {reuslt:0,content:'托清单未找到!'}
      end
    end

    # update forklift
    put do
      result = ForkliftService.update(forklift_params)
      if result
        {result:1,content:''}
      else
        {result:0,content:''}
      end
    end
  end
end