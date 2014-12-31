module V2
  class PackagesAPI<Base
    namespace :packages

    #=============
    # url: GET /packages
    # params: state=[],created_at=start..end,user_id=user_id,destination_id=user.location_id,sort
    #=============
    get do
      pa = ParamsService.parse_to_search(params)
      PackagePresenter.init_json_presenters(PackageService.where(pa[:args]).order(pa[:sort]).all)
    end

    #=============
    # url: POST /packages
    #=============
    post do

    end

    #=============
    # url: GET /packages/:id
    #=============
    get ':id' do

    end

    #=============
    # url: PUT /packages/:id
    #=============
    put ':id' do

    end

    #=============
    # url: DELETE /packages/:id
    #=============
    delete ':id' do

    end

    #=============
    # url: PUT /packages/:id/check
    #=============
    put ':id/check' do

    end

    #=============
    # url: DELETE /packages/:id/check
    #=============
    delete ':id/check' do

    end

    #=============
    # url: PUT /packages/:id/reject
    #=============
    put ':id/reject' do

    end

    #=============
    # url: DELETE /packages/:id/reject
    #=============
    delete ':id/reject' do

    end
  end
end