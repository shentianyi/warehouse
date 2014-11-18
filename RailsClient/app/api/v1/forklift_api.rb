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
      args=forklift_params
      args.delete(:stocker_id)
      args[:destinationable_id] = args[:whouse_id]
      args.delete(:whouse_id)

      msg = ForkliftService.create(args, current_user)
      msg.result ? {result: 1, content: ForkliftPresenter.new(msg.object).to_json} : {result: 0, content: msg.content}
    end

    post :add do
      p1=LogisticsContainer.build(params[:id], current_user.id, current_user.location_id)
      p2=LogisticsContainer.build(params[:pid], current_user.id, current_user.location_id)

      p1.add(p2)
    end

    # add package
    post :check_package do
      unless f=LogisticsContainer.exists?(params[:forklift_id])
        return {result: 0, result_code: ResultCodeEnum::Failed, content: ForkliftMessage::NotExit}
      end

      # unless ForkliftState.can_update?(f.state)
      #   return {result: 0, result_code: ResultCodeEnum::Failed, content: ForkliftMessage::CannotUpdate}
      # end
      unless f.can? 'update'
        return {result: 0, result_code: ResultCodeEnum::Failed, content: ForkliftMessage::CannotUpdate}
      end

      unless pc= Package.exists?(params[:package_id])
        return {result: 0, result_code: ResultCodeEnum::Failed, content: PackageMessage::NotExit}
      end

      p=LogisticsContainer.build(params[:package_id], current_user.id, current_user.location_id)

      unless p.can_add_to_container?
        return {result: 0, result_code: ResultCodeEnum::Failed, content: PackageMessage::InOtherForklift}
      end

      # f=LogisticsContainer.build(params[:forklift_id], current_user.id, current_user.location_id)
      if f.add(p)
        {result: 1, result_code: ResultCodeEnum::Success, content: PackagePresenter.new(pc).to_json}
      else
        {result: 0, result_code: ResultCodeEnum::Failed, content: ForkliftMessage::AddPackageFailed}
      end
      #
      # if ForkliftService.add_package(f, p)
      #   puts "------------------------------"
      #   puts p.position
      #   puts "------------------------------"
      #   unless p.position.nil?
      #     {result: 1, result_code: ResultCodeEnum::Success, content: PackagePresenter.new(p).to_json}
      #   else
      #     {result: 1, result_code: ResultCodeEnum::TargetNotInPosition, content: PackagePresenter.new(p).to_json}
      #   end
      # else
      #   {result: 0, result_code: ResultCodeEnum::Failed, content: ForkliftMessage::AddPackageFailed}
      # end
    end

# add package
    post :add_package do
      unless f=LogisticsContainer.exists?(params[:forklift_id])
        return {result: 0, result_code: ResultCodeEnum::Failed, content: ForkliftMessage::NotExit}
      end

      unless f.can? 'update'
        return {result: 0, content: {message: ForkliftMessage::CannotUpdate}}
      end
      #
      # unless ForkliftState.can_update?(f.state)
      #   return {result: 0, content: {message: ForkliftMessage::CannotUpdate}}
      # end
      #
      #create package
      args = {
          id: params[:package_id],
          part_id: params[:part_id],
          quantity_str: params[:quantity_str],
          check_in_time: params[:check_in_time]
      }
      #
      res = PackageService.create(args, current_user)
      if res.result
        lc_p = res.object
        # f=LogisticsContainer.build(params[:forklift_id], current_user.id, current_user.location_id)
        if f.add(lc_p)
          {result: 1, result_code: ResultCodeEnum::Success, content: PackagePresenter.new(lc_p.container).to_json}
          # part = Part.find_by_id(params[:part_id])
          # if part.positions.where(whouse_id: f.whouse_id).count > 0 || part.positions.count == 0
          #   {result: 1, result_code: ResultCodeEnum::Success, content: PackagePresenter.new(p).to_json}
          # else
          #   {result: 1, result_code: ResultCodeEnum::TargetNotInPosition, content: PackagePresenter.new(p).to_json}
          # end
        else
          {result: 0, result_code: ResultCodeEnum::Failed, content: ForkliftMessage::AddPackageFailed}
        end
      else
        {result: 0, result_code: ResultCodeEnum::Failed, content: res.content}
      end
    end

# remove package
# id is forklift_item_id
    delete :remove_package do
      unless (p=LogisticsContainer.exists?(params[:package_id]))
        return {result: 0, content: PackageMessage::NotExit}
      end

      unless p.can? 'update'
        return {result: 0, content: PackageMessage::CannotUpdate}
      end
      #
      # if !PackageState.can_update?(p.state)
      #   return {result: 0, content: PackageMessage::CannotUpdate}
      # end

      {result: p.remove ? 1 : 0, content: ''}
    end

#delete forklift
    delete do
      unless f = ForkliftService.exits?(params[:id])
        return {result: 0, content: ForkliftMessage::NotExit}
      end
      #unless ForkliftState.can_delete?(f.state)
      #  return {result: 0, content: ForkliftMessage::CannotUpdate}
      #end

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

      #if !ForkliftState.can_update?(f.state)
      #  return {result: 0, content: ForkliftMessage::CannotUpdate}
      #end

      if forklift_params[:whouse_id]
        unless ForkliftService.parts_in_whouse?(f.packages.collect { |p| p.part_id }, forklift_params[:whouse_id])
          return {return: 0, content: ForkliftMessage::CannotUpdatePartsNotExistInWhouse}
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