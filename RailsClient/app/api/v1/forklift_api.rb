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
      args={
          delivery_id: nil
      }
      forklifts = ForkliftService.search(args)
      data = []
      ForkliftPresenter.init_presenters(forklifts).each do |fp|
        data<<fp.to_json
      end
      data
    end

    # create forklift
    post do
      msg = ForkliftService.create(forklift_params,current_user)
      if msg.result
        {result:1,content:ForkliftPresenter.new(msg.object).to_json}
      else
        {result:0,content:msg.content}
      end
    end

    # check package
    post :check_package do
      unless f = ForkliftService.exits?(params[:forklift_id])
        return {result:0,content:'清单不存在!'}
      end
      unless ForkliftState.can_update?(f.state)
        return {result:0,content:'清单不能修改!'}
      end
      unless p = PackageService.exits?(params[:package_id])
        return {result:0,content:'包装箱不存在!'}
      end

      if ForkliftService.add_package(f,p)
        {result:1,content:PackagePresenter.new(p).to_json}
      else
        {result:0,content:'添加失败!'}
      end
    end

    # add package
    post :add_package do
      if (f = ForkliftService.exits?(params[:forklift_id])).nil?
        return {result:0,content:'清单不存在!'}
      end

      if !ForkliftState.can_update?(f.state)
        return {result:0,content:'清单不能修改!'}
      end

      #create package
      args = {
          id:params[:package_id],
          part_id:params[:part_id],
          quantity_str:params[:quantity_str],
          check_in_time:params[:check_in_time]
      }
      args[:user_id] = params[:user_id] if params.has_key?(:user_id)

      res = PackageService.create(args,current_user)
      if res.result
        p = res.object
        if p
          if ForkliftService.add_package(f,p)
            {result:1,content:PackagePresenter.new(p).to_json}
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
      if (p = PackageService.exits?(params[:package_id])).nil?
        return{result:0,content:'包装箱不存在!'}
      end

      if !PackageState.can_update?(p.state)
        return {result:0,content:'包装箱不能修改!'}
      end

      if ForkliftService.remove_package(p)
        {result:1,content:''}
      else
        {result:0,content:''}
      end

    end

    #delete forklift
    delete do
      if (f = ForkliftService.exits?(params[:id])).nil?
        return {result:0,content:'清单不存在!'}
      end
      if !ForkliftState.can_delete?(f.state)
        return {result:0,content:'清单不能修改!'}
      end
      result = ForkliftService.delete(f)
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
      if (f = ForkliftService.exits?(forklift_params[:id])).nil?
        return {result:0,content:'清单不存在!'}
      end

      if !ForkliftState.can_update?(f.state)
        return {result:0,content:'清单不能修改!'}
      end

      result = ForkliftService.update(f,forklift_params)
      if result
        if forklift_params[:whouse_id]
          packages = PackagePresenter.init_presenters(f.packages).collect {|p| p.to_json}
          {result:1,content:{packages:packages}}
        else
          {result:1,content:'更新清单成功'}
        end

      else
        {result:0,content:'更新清单失败'}
      end
    end
  end
end