module V1
  class ForkliftAPI<Base
    namespace :forklifts
    guard_all!

    #strong parameters
    helpers do
      def forklift_params
        ActionController::Parameters.new(params).require(:forklift).permit(:whouse_id, :user_id, :remark, :stocker_id, :id)
      end
    end

    # get binded but not add to delivery forklifts
    get :binds do
      args={
          delivery_id: nil
      }
      unless params.has_key?(:all)
        args[:user_id]=current_user.id
      end
      forklifts = ForkliftService.search(args)
      data = []
      ForkliftPresenter.init_presenters(forklifts).each do |fp|
        data<<fp.to_json
      end
      data
    end

    # create forklift
    post do
      msg = ForkliftService.create(forklift_params, current_user)
      if msg.result
        {result: 1, content: ForkliftPresenter.new(msg.object).to_json}
      else
        {result: 0, content: msg.content}
      end
    end

    # check package
    post :check_package do
      unless f = ForkliftService.exits?(params[:forklift_id])
        return {result: 0, content: ForkliftMessage::NotExit}
      end
      unless ForkliftState.can_update?(f.state)
        return {result: 0, content: ForkliftMessage::CannotUpdate}
      end
      unless p = PackageService.exits?(params[:package_id])
        return {result: 0, content: PackageMessage::NotExit}
      end
      unless ForkliftService.parts_in_whouse?([p.part_id],f.whouse_id)
        return {return: 0, content:PackageMessage::PartNotInWhouse}
      end

      if ForkliftService.add_package(f, p)
        {result: 1, content: PackagePresenter.new(p).to_json}
      else
        {result: 0, content: ForkliftMessage::AddPackageFailed}
      end
    end

    # add package
    post :add_package do
      unless f = ForkliftService.exits?(params[:forklift_id])
        return {result: 0, content: ForkliftMessage::NotExit}
      end

      unless ForkliftState.can_update?(f.state)
        return {result: 0, content: ForkliftMessage::CannotUpdate}
      end

      #create package
      args = {
          id: params[:package_id],
          part_id: params[:part_id],
          quantity_str: params[:quantity_str],
          check_in_time: params[:check_in_time]
      }
      args[:user_id] = params[:user_id] if params.has_key?(:user_id)

      res = PackageService.create(args, current_user)
      if res.result
        p = res.object
        if ForkliftService.add_package(f, p)
          {result: 1, content: PackagePresenter.new(p).to_json}
        else
          {result: 0, content: ForkliftMessage::AddPackageFailed}
        end
      else
        {result: res.result, content: res.content}
      end
    end

    # remove package
    # id is forklift_item_id
    delete :remove_package do
      if (p = PackageService.exits?(params[:package_id])).nil?
        return {result: 0, content: PackageMessage::NotExit}
      end

      if !PackageState.can_update?(p.state)
        return {result: 0, content: PackageMessage::CannotUpdate}
      end

      if p.remove_from_forklift
        {result: 1, content: ''}
      else
        {result: 0, content: ''}
      end

    end

    #delete forklift
    delete do
      unless f = ForkliftService.exits?(params[:id])
        return {result: 0, content: ForkliftMessage::NotExit}
      end
      unless ForkliftState.can_delete?(f.state)
        return {result: 0, content: ForkliftMessage::CannotUpdate}
      end
      ForkliftService.delete(f)
      {result: 1, content: ''}
    end

    # get forklift detail
    get :detail do
      f = Forklift.find_by_id params[:id]
      if f
        fp = ForkliftPresenter.new(f)
        {result: 1, content: fp.to_json_with_packages}
      else
        {reuslt: 0, content: ForkliftMessage::NotExit}
      end
    end

    # update forklift
    put do
      if (f = ForkliftService.exits?(forklift_params[:id])).nil?
        return {result: 0, content: ForkliftMessage::NotExit}
      end

      if !ForkliftState.can_update?(f.state)
        return {result: 0, content: ForkliftMessage::CannotUpdate}
      end

      if forklift_params[:whouse_id]
        unless ForkliftService.parts_in_whouse?(f.packages.collect { |p| p.part_id },f.whouse_id)
          return {return:0, content: ForkliftMessage::CannotUpdatePartsNotExistInWhouse}
        end
      end

      result = ForkliftService.update(f, forklift_params)
      if result
        if forklift_params[:whouse_id]
          packages = PackagePresenter.init_presenters(f.packages).collect { |p| p.to_json }
          {result: 1, content: {packages: packages}}
        else
          {result: 1, content: ForkliftMessage::UpdateSuccess}
        end

      else
        {result: 0, content: ForkliftMessage::UpdateFailed}
      end
    end
  end
end