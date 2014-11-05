require 'rails_helper'

	describe 'POST /api/v1/users/login' do
    before(:each) do
      @user = create(:user)
    end

    it "should login succefully" do
      post '/api/v1/users/login', :user => {:id => "#{@user.id}",:password => "1111"}
      expect(JSON.parse(response.body)).to eq({"result"=> 1,"content"=> 400})
    end
	end