module V1
  class PackageAPI<Base
    namespace :packages
    guard_all!

    #strong parameters
    helpers do
      def package_params
        ActionController::Parameters.new(params).require(:package).permit(:id,:part_id,:quantity_str,:check_in_time,:user_id)
      end
    end

    #
    #******
    #need to add conditions for search
    #******
    # binded but not add to forklift packages
    get :binds do
      packages = PackageService.avaliable_to_bind
      data = []
      presenters = PackagePresenter.init_presenters(packages)
      presenters.each do |p|
        data<<p.to_json
      end
      data
    end

    # validate package id
    post :validate do
      result = PackageService.valid_id?(params[:id])
      if result
        {result:1, content: '唯一号可用'}
      else
        {result:0, content: '唯一号不可用!'}
      end
    end

    # validate quantity string
    post :validate_quantity do
      result = PackageService.valid_quantity?(params[:id])
      if result
        {result:1, content: '包裝箱數量格式正確'}
      else
        {result:0, content: '包裝箱數量格式錯誤!'}
      end
    end

    # create package
    # if find deleted then update(take care of foreign keys)
    # else create new
    post do
      # every package has a uniq id,id should not be exits
      m = PackageService.create package_params,current_user
      if m.result
        {result:1,content:PackagePresenter.new(m.object).to_json}
      else
        {result:0,content:m.content}
      end
    end

    # update package
    put do
      if p = PackageService.exits?(package_params[:id])
        if PackageService.update(p,package_params)
          {result:1,content:'修改成功!'}
        else
          {result:0,content:'修改失败!'}
        end
      else
        {result:0,content:'包装箱不存在!'}
      end
    end

    # delete package
    # update is_delete to true
    delete do
      if p = PackageService.exits?(params[:id])
        if PackageService.delete(p)
          {result:1,content:'删除成功'}
        else
          {result:0,content:'删除失败'}
        end
      else
        {result:0,content:'包装箱不存在!'}
      end
    end

    # check package
    post :check do
      if p = PackageService.exits?(params[:id])
        if PackageService.check(p)
          {result:1,content:'检查成功'}
        else
          {result:0,content:'检查失敗'}
        end
      else
        {result:0,content:'包装箱不存在!'}
      end
    end

    # uncheck package
    post :uncheck do
      if p = PackageService.exits?(params[:id])
        if PackageService.uncheck(p)
          {result:1,content:'取消检查成功'}
        else
          {result:0,content:'取消检查失敗'}
        end
      else
        {result:0,content:'包装箱不存在!'}
      end
    end
  end
end