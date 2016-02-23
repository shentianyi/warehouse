require 'rails_helper'

RSpec.describe "UserPermissionGroups", type: :request do
  describe "GET /user_permission_groups" do
    it "works! (now write some real specs)" do
      get user_permission_groups_path
      expect(response).to have_http_status(200)
    end
  end
end
