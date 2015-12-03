#encoding: utf-8
module V1
  class UserAPI<Base
    namespace :users do

      #extend Devise::Controllers::SignInOut
      # login
      # params: email, passwd
      post :login do
        user = User.find_for_database_authentication(user_name: params[:user][:id])
        if user
          if user.valid_password?(params[:user][:password])
            warden.set_user user

            if SysConfigCache.inventory_enable_value=='true' && (current_user.sender? || current_user.receiver? || current_user.stocker? || current_user.shifter? || current_user.buyer?)
              # error!({result: 0, content: '盘点中...登陆锁定'}, 401)
              {result: 0, content: '盘点中...登陆锁定'}
            else
              {result: 1, content: {role_id: current_user.role_id, location_id: current_user.location_id, location_name: current_user.location.name, operation_mode: current_user.operation_mode}}
            end
          else
            # error!({result: 0, content: '密码错误'}, 401)
            {result: 0, content: '密码错误'}
          end
        else
          # error!({result: 0, content: '员工号错误'}, 401)
          {result: 0, content: '员工号错误'}
        end
      end

      # logout
      delete :logout do
        warden.raw_session.inspect
        warden.logout
        {result: 1}
      end

      get do
        guard!
        {result: 1, content: {user: User.first}}
      end

      get :ping do
        'ping'
      end
    end
  end
end
