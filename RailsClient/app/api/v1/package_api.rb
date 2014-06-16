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

    # get binded but not add to forklift packages
    get :binds do
      packages = PackageService.avaliable_to_bind
      data = []
      packages.all.each do |p|
        data<<{id:p.id,quantity_str:p.quantity_str,part_id:p.part_id,user_id:p.user_id,check_in_time:p.check_in_time}
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
      p = PackageService.create package_params,current_user
      if p
        {result:1,content:{id:p.id,part_id:p.part_id,quantity_str:p.quantity_str,user_id:p.user_id,check_in_time:p.check_in_time}}
      else

      end
      {result:0,content:''}
    end

    # update package
    patch do
      result = PackageService.update(params[:id],package_params)
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