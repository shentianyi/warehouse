require 'rails_helper'

describe V1::PackageAPI do

  before(:all) do
    @user = create(:user)
    login(@user)

    @part = create(:part)
  end

  after(:all) do
    logout
  end

  describe "GET /api/v1/packages/binds " do

    it "should get packages" do
      get "/api/v1/packages/binds"

      expect(response.status).to eq(200)
    end
  end

  describe "POST /api/v1/packages/validate" do
    it "should get valid id" do
      post "/api/v1/packages/validate",{id:"WI110"}
      puts JSON.parse(response.body)
      expect(JSON.parse(response.body)).to eq({"result" => 1,"content" => ""})
    end
  end
end