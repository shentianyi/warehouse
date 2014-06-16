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
      ForkliftPresenter.init_presenters(forklifts).each do |fp|
        data<<fp.to_json
      end
      data
    end

    # create forklift
    post do
      if Whouse.find_by_id(forklift_params[:whouse_id]).nil?
        {result:0,content:'部门未找到'}
        return
      end
      f = Forklift.new(forklift_params)
      unless forklift_params.has_key?(:user_id)
        f.user = current_user
      end
      if f.save
        {result:1,content:ForkliftPresenter.new(f).to_json}
      else
        {result:0,content:f.errors.full_messages}
      end
    end

    # check package
    post :check_package do
      f = Forklift.find_by_id(params[:forklift_id])
      p = Package.find_by_id(params[:package_id])
      if f && p && p.forklift.nil?
        p.forklift = f
        if p.save
          return {
              result:1,
              content:''
          }
        end
      else

      end
        {result:0,content:''}
    end

    # add package
    post :add_package do
      args = {
          id:params[:package_id],
          part_id:params[:part_id],
          quantity_str:params[:quantity_str],
          check_in_time:params[:check_in_time]
      }
      args[:user_id] = params[:user_id] if params.has_key?(:user_id)
      res = PackageService.create(args,current_user)
      if res == 1
        p = res.content
        f = Forklift.find_by_id(params[:forklift_id])
        if p && f
          p.forklift = f
          f.sum_packages = f.sum_packages + 1
          if f.save && p.save
            {result:1,content:{id:p.id,quantity_str:p.quantity_str,part_id:p.part_id,user_id:p.user_id,check_in_time:p.check_in_time}}
          else
            {result:0,content:'添加包装箱失败'}
          end
        else
          {
              result:0,
              content:'托清单不存在!'
          }
        end
      else
        {result:res.result,content:res.content}
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
      if f
        fp = ForkliftPresenter.new(f)
        {result:1,content:fp.to_json_with_packages}
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