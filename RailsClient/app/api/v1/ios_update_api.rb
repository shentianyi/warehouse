module V1
  class IosUpdateAPI<Base
    namespace :ios_updates

    get :update_info do
      if update_info = IosUpdate.find
        {result:update_info.old_version?(params[:version]),is_force:update_info.is_force_update?}
      else
        {result:0,is_force:0}
      end
    end
  end
end