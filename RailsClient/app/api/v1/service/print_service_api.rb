module V1 
  module Service
    class PrintServiceAPI<ServiceBase
      namespace 'printer'
      guard_all!
      
      get :print do
        {Name:'printer',Code:'P002'}
      end
    end
  end
end