module V1
  module Service
    class PrintServiceAPI<ServiceBase
      namespace 'printer'
      guard_all!

      get :print do
        set=[]
        for i in 0...10
          data=[]
          [:Body,:Head].each{|key|
            data<<{Key: key, Value: 'Value'+i.to_s}
          }
          set<<data
        end
        puts set.to_json
        set
      end
    end
  end
end