module V1
  class PackageAPI<Base
    namespace :packages
    guard_all!

    #strong parameters
    helpers do
      def packages_params
        ActionController::Parameters.new(params).require(:package).permit(:part_id,:quantity)
      end
    end

    # get binded but not add to forklift packages
    get :binds do
      packages = PackageService.avaliable_to_bind
      data = []
      packages.all.each do |p|
        data<<{id:p.id,quantity:p.quantity_str,part_id:p.part_id,user_id:p.user_id,check_in:p.check_in_time}
      end
      data
    end

    # validate package id
    post :validate do
      result = PackageService.id_avaliable?(params[:id])
      {result:result, content: ''}
    end

    post :validate_quantity do
      result = PackageService.validate_quantity(params[:quantity])
      {result:result, content: ''}
    end

    # create package
    # if find deleted then update(take care of foreign keys)
    # else create new
    post do
      package = params[:package]
      result = PackageService.create package,current_user
      {result:result,content:''}
    end

    # update package
    patch do
      result = PackageService.update(params[:id],packages_params)
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

    end
  end
end