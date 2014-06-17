module V1
  class PartAPI<Base
    namespace :parts
    guard_all!
    post :validate do
     if PartService.validate_id params[:id]
       {result:1,content:''}
     else
       {result:0,content:''}
     end
    end
  end
end