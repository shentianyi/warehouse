require 'rails_helper'

describe V1::PackageAPI do
  before(:all) do
    # create(:p1)
    # create(:p2)
    login
  end

  describe 'create with user id' do
    it 'return true' do
      @admin=build(:admin)
      post '/api/v1/packages', package: {custom_id: 101, part_id: 1 , quantity: '300.00', fifo_time: '23.03.14', user_id: @admin.id}
      expect(response.status).to eq(201)
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