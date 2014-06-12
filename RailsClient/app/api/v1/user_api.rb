module V1
  class UserAPI<Base
    extend Devise::Controllers::SignInOut
    namespace 'users'
    #guard_all!

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
  end
end