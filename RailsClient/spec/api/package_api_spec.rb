require 'rails_helper'

describe V1::PackageAPI do
  before(:each) do
    create(:p1)
    create(:p2)
    create(:p3)

  end

  describe 'binds without user & forklift' do
    it 'returns 3' do
      login_user
      get '/api/v1/packages/binds'
      expect(response.status).to eq(200)
      puts response.body
    end
  end
end