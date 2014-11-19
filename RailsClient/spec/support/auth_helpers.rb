module AuthHelpers
  def method_missing(method_name,*args,&block)
    if /^login_as_[a-z]*/ =~ 
  end

  def login_as_sender
    post '/api/v1/users/login',{user:{id:@sender.id,password:'1111'}}
  end

  def logout
    delete '/api/v1/users/logout'
  end

  def json
    @json ||= JSON.parse(response.body)
  end
end