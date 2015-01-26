module V2
  class UserSessionsAPI<Base
    namespace :user_sessions

    #=============
    # url: POST /user_sessions
    #=============
    post do
      user = User.find_for_database_authentication(user_name: params[:user][:id])
      if user
        if user.valid_password?(params[:user][:password])
          warden.set_user user
          {result: 1, content: {user:{role_id:current_user.role_id,location_id:current_user.location_id,location_name:current_user.location.name,operation_mode: current_user.operation_mode}}}
        else
          error!({result: 0, content: '密码错误'}, 401)
        end
      else
        error!({result: 0, content: '员工号错误'}, 401)
      end
    end

    #=============
    # url: DELETE /user_sessions
    #=============
    delete do
      warden.raw_session.inspect
      warden.logout
      {result: 1}
    end
  end
end