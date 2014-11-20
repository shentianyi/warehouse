module AuthHelpers
  def login_as_receiver
    post '/api/v1/users/login', {user:{id:@receiver.id,password:'1111'}}
  end

  def login_as_sender
    post '/api/v1/users/login',{user:{id:@sender.id,password:'1111'}}
  end

  def login_as_admin
    post '/api/v1/users/login',{user:{id:@admin.id,password:'1111'}}
  end

  #Roles.each do |r|
  #  define_method(('login_as'+r).to_sym){
  #    post '/api/v1/users/login',{user:{id:instance_variable_get("@"+r).id,password:'1111'}}
  #  }
  #end

  def logout
    delete '/api/v1/users/logout'
  end

  def json
    @json ||= JSON.parse(response.body)
  end
end