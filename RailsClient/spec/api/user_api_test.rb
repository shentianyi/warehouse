require 'rails_helper'

	describe 'POST /api/v1/user/login' do
    before(:each) do
      @user = create(:user)
      @user.confirm!
      controller.sign_in(@user)
    end
	end