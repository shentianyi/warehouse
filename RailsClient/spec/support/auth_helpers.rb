module AuthHelpers
  def login(user)
    post '/api/v1/users/login',{user:{id:user.id,password:'1111'}}
  end

  def logout(user)
    delete '/api/v1/users/logout'
  end
end