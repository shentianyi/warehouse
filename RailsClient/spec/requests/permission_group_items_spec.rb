require 'rails_helper'

RSpec.describe "PermissionGroupItems", type: :request do
  describe "GET /permission_group_items" do
    it "works! (now write some real specs)" do
      get permission_group_items_path
      expect(response).to have_http_status(200)
    end
  end
end
