require 'rails_helper'

describe V1::PackageAPI do
  before(:each) do
    create(:p1)
    create(:p2)
    login
  end

  describe 'create with user id' do
    it 'return true' do
      @admin=create(:admin)
      post '/api/v1/packages',package:{custom_id:'P001',part_id:'p001',quantity:'300.00',check_in_time:'23.03.14',user_id:@admin.id}
      expect(response.status).to eq(200)
      puts JSON.parse(response.body)
    end
  end
  # describe 'binds without user & forklift' do
  #   it 'returns 3' do
  #     get '/api/v1/packages/binds'
  #     expect(response.status).to eq(200)
  #     puts response.body
  #   end
  # end

  after(:each) do
    logout
  end
end