module V1
  class UserAPI<Base
    namespace 'users'
    guard_all!

    # login
    # params: email, passwd
    post :login do
      email = params[:email]
      password = params[:password]
      if email.nil? || password.nil?
        render :status=>400,:json=>{:message => "Must give email and password!"}
        return
      end

      user = User.find_by_email(email)
      if user.nil?
        return
      end

      user.ensure_authentication_token!
      if not user.valid_password?(password)

      else
        render :status=>200, :json=>{:token=>user.authentication_token}
      end
    end

    # logout
    delete :logout do

    end
  end
end