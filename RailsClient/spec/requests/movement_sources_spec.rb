require 'rails_helper'

RSpec.describe "MovementSources", type: :request do
  describe "GET /movement_sources" do
    it "works! (now write some real specs)" do
      get movement_sources_path
      expect(response).to have_http_status(200)
    end
  end
end
