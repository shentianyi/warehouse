module V1
  class UserAPI<Base
    namespace :users
    #guard_all!

    extend Devise::Controllers::SignInOut
    # login
    # params: email, passwd
    post :login do
      resource = warden.authenticate!(:scope => :user)
      sign_in(:user,resource)
      render :json=>"Message"
    end

    # logout
    delete :logout do

    end

    get do
      {result:true,content:{user:User.first}}
    end
  end
end
