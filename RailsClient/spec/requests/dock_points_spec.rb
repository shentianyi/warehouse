require 'rails_helper'

RSpec.describe "DockPoints", type: :request do
  describe "GET /dock_points" do
    it "works! (now write some real specs)" do
      get dock_points_path
      expect(response).to have_http_status(200)
    end
  end
end
