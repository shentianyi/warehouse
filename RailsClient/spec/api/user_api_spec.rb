require 'rails_helper'

describe V1::UserAPI do
  describe 'POST /api/v1/users/sign_in' do
    it 'returns true' do
      post '/api/v1/users/login',{user:{id:'504435'},password:'123456@'}
      response.status.should==200
      JSON.parse(response.body).should=={result: 1, content: 300}
      puts response.body
    end
  end
end