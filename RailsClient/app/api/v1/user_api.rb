module V1
  class UserAPI<Base
    namespace 'users'
    guard_all!

    # login
    # params: email, passwd
    post :login do

    end

    # logout
    delete :logout do

    end

  end
end