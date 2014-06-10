module V1
  class UserAPI<Base
    namespace 'users'
    get do
     request.env['warden'].user.to_json
    end
  end
end