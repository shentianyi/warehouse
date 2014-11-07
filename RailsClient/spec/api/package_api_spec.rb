require 'rails_helper'

describe V1::PackageAPI do
  before(:each) do
    @user = create(:user)
    login(@user)
  end

  after(:each) do
    logout(@user)
  end

  describe "GET /api/v1/packages/binds " do

    it "should get packages" do
      get "/api/v1/packages/binds"

      puts(JSON.parse(response.body))
      expect(response.status).to eq(200)
    end
  end
end