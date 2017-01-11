require 'rails_helper'

RSpec.describe "MovementLists", type: :request do
  describe "GET /movement_lists" do
    it "works! (now write some real specs)" do
      get movement_lists_path
      expect(response).to have_http_status(200)
    end
  end
end
