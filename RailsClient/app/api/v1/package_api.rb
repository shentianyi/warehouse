module V1
  class PackageAPI<Base
    namespace :packages
    guard_all!

    #strong parameters
    helpers do
      def package_params
        ActionController::Parameters.new(params).require(:package).permit(:id, :custom_id, :part_id, :quantity, :fifo_time, :user_id)
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
      unless params.has_key?(:all)
        args[:user_id]=current_user.id
      end
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
        {result: 1, content: ''}
      else
        {result: 0, content: PackageMessage::IdNotValid}
      end
    end

    # validate quantity string
    post :validate_quantity do
      result = true #PackageService.quantity_string_valid?(params[:id])
      if result
        {result: 1, content: ''}
      else
        {result: 0, content: PackageMessage::QuantityStringError}
      end
    end

    # create package
    # if find deleted then update(take care of foreign keys)
    # else create new
    post do
      # every package has a uniq id,id should not exited
      m = PackageService.create package_params, (package_params.has_key?(:user_id) ? User.find_by_id(package_params[:user_id]) : current_user)
      m.result ? {result: 1, content: PackagePresenter.new(m.object).to_json_simple} : {result: 0, content: m.content}
    end

    # update package
    put do
      msg = PackageService.update(package_params)
      if msg.result
        {result: 1, content: PackagePresenter.new(msg.object).to_json}
      else
        {result: 0, content: msg.content}
      end
    end

    # delete package
    # update is_delete to true
    delete do
      msg = PackageService.delete(params[:id])
      if msg.result
        {result: 1, content: PackageMessage::DeleteSuccess}
      else
        {result: 0, content: msg.content}
      end
    end

    # check package
    post :check do
      msg = PackageService.check(params[:id])
      if msg.result
        {result: 1, content: msg.content}
      else
        {result: 0, content: msg.content}
      end
    end

    # uncheck package
    post :uncheck do
      msg = PackageService.uncheck(params[:id])
      if msg.result
        {result: 1, content: msg.content}
      else
        {result: 0, content: msg.content}
      end
    end
  end
end