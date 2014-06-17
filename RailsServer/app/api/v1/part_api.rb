module V1
  class PartAPI<Base
    namespace :parts
    guard_all!
    post :validate do
      result = PartService.validate_id params[:id]
      {result:result,content:''}
    end
  end
end