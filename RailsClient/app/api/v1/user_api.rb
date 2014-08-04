#encoding: utf-8
module V1
  class UserAPI<Base
    namespace :users

    #extend Devise::Controllers::SignInOut
    # login
    # params: email, passwd
    post :login do
      user = User.find_for_database_authentication(id: params[:user][:id])
      if user
        if user.valid_password?(params[:user][:password])
          warden.set_user user
          {result: 1, content: current_user.role_id}
        else
          error!({result: 0, content: '密码错误'}, 401)
        end
      else
        error!({result: 0, content: '员工号错误'}, 401)
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
