module V1
  class UserAPI<Base
    namespace :users
    #guard_all!

    extend Devise::Controllers::SignInOut
    # login
    # params: email, passwd
    post :login do
=begin
      user = User.find_for_database_authentication(id: params[:user][:id])
      if user && user.valid_password?(params[:user][:password])
        warden.set_user user
        {result:true}
      else
        {result:false}
      end
=end
    end

    # logout
    delete :logout do
=begin
      warden.raw_session.inspect
      warden.logout
=end
    end

    get do
      {result:true,content:{user:User.first}}
    end
  end
end
