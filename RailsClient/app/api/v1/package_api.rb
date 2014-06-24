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

    #******
    #need to add conditions for search
    #******
    # binded but not add to forklift packages
    # no need to show position
    get :binds do
      args = {
          forklift_id: nil
      }

      packages = PackageService.search(args)
      data = []
      presenters = PackagePresenter.init_presenters(packages)
      presenters.each do |p|
        data<<p.to_json_simple
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
      result = PackageService.quantity_string_valid?(params[:id])
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
      # every package has a uniq id,id should not exited
      m = PackageService.create package_params,current_user
      if m.result
        {result:1,content:PackagePresenter.new(m.object).to_json_simple}
      else
        {result:0,content:m.content}
      end
    end

    # update package
    put do
      msg = PackageService.update(package_params)
      if msg.result
        {result:1,content:PackagePresenter.new(msg.object).to_json}
      else
        {result:0,content:msg.content}
      end
    end

    # delete package
    # update is_delete to true
    delete do
      msg = PackageService.delete(params[:id])
      if msg.result
        {result:1,content:'删除成功！'}
      else
        {result:0,content:msg.content}
      end
    end

    # check package
    post :check do
      msg = PackageService.check(params[:id])
      if msg.result
        {result:1,content:msg.content}
      else
        {result:0,content:msg.content}
      end
    end

    # uncheck package
    post :uncheck do
      msg = PackageService.uncheck(params[:id])
      if msg.result
        {result:1,content:msg.content}
      else
        {result:0,content:msg.content}
      end
    end
  end
end