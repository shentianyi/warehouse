require 'rails_helper'

RSpec.describe "WrappageMovementItems", type: :request do
  describe "GET /wrappage_movement_items" do
    it "works! (now write some real specs)" do
      get wrappage_movement_items_path
      expect(response).to have_http_status(200)
    end
  end
end
