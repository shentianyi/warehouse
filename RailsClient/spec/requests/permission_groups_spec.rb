require 'rails_helper'

RSpec.describe "PermissionGroups", type: :request do
  describe "GET /permission_groups" do
    it "works! (now write some real specs)" do
      get permission_groups_path
      expect(response).to have_http_status(200)
    end
  end
end
