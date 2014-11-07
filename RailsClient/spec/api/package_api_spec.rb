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

  describe "Bind package" do
    it "should get valid id" do
      post "/api/v1/packages/validate",{id:"WI110"}
      expect(JSON.parse(response.body)).to eq({"result" => 1,"content" => ""})
    end

    it "should create package successfully" do
      post "/api/v1/packages" ,{package:{id:"WI001",part_id:@part.id,quantity_str:"Q100.00",check_in_time:"W10 12"}}
      expect(JSON.parse(response.body)).to eq(1)
    end
  end
end