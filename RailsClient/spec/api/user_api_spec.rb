require 'rails_helper'

describe V1::UserAPI do
  describe 'sign_in' do
    it 'returns true' do
      post '/api/v1/users/login',{user:{id:@sender.id,password:'1111'}}
      expect(response.status).to eq(201)
      expect(JSON.parse(response.body)['result']).to eq(1)
    end
  end

end