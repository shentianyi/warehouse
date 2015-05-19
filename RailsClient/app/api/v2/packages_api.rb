module V2
  class PackagesAPI<Base
    namespace :packages do

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
        #Todo
      end

      #=============
      # url: GET /packages/:id
      #=============
      get ':id' do
        #Todo
      end

      #=============
      # url: PUT /packages/:id
      #=============
      put ':id' do
        #Todo
      end

      #=============
      # url: DELETE /packages/:id
      #=============
      delete ':id' do
        #Todo
      end

      #=============
      # url: PUT /packages/:id/check
      #=============
      put ':id/check' do
        #Todo
      end

      #=============
      # url: DELETE /packages/:id/check
      #=============
      delete ':id/check' do
        #Todo
      end

      #=============
      # url: PUT /packages/:id/reject
      #=============
      put ':id/reject' do
        #Todo
      end

      #=============
      # url: DELETE /packages/:id/reject
      #=============
      delete ':id/reject' do
        #Todo
      end
    end
  end
end