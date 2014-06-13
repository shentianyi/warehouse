require 'rails_helper'

#describe V1::UserAPI do
  describe 'POST /api/sign_in' do
    it 'returns true' do
      post '/api/sign_in'
      response.status.should==200
      JSON.parse(response.body).should=={result:true,content:100}
    end
  end
#end