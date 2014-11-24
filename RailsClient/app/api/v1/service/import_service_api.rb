module V1
  module Service
    class ImportServiceAPI<ServiceBase
      namespace 'import'
      guard_all!

      post :store_container do
        params[:containers].each do |container|
          c=Container.create()
        end
      end
    end
  end
end