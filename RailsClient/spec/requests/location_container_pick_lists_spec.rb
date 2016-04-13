require 'rails_helper'

RSpec.describe "LocationContainerPickLists", type: :request do
  describe "GET /location_container_pick_lists" do
    it "works! (now write some real specs)" do
      get location_container_pick_lists_path
      expect(response).to have_http_status(200)
    end
  end
end
