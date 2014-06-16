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
      result = PackageService.id_avaliable?(params[:id])
      {result:result, content: ''}
    end

    # validate quantity string
    post :validate_quantity do
      result = PackageService.validate_quantity(params[:quantity])
      {result:result, content: ''}
    end

    # create package
    # if find deleted then update(take care of foreign keys)
    # else create new
    post do
      # every package has a uniq id,id should not be exits
      p = PackageService.create package_params,current_user
      if p
        {result:1,content:PackagePresenter.new(p.content).to_json}
      else
        {result:0,content:''}
      end
    end

    # update package
    put do
      result = PackageService.update(package_params)
      {result:result,content:''}
    end

    # delete package
    # update is_delete to true
    delete do
      result = PackageService.delete params[:id]
      {result:result,content:''}
    end

    # check package
    post :check do
      result = PackageService.check(params[:id])
      {result:result,content:''}
    end
  end
end