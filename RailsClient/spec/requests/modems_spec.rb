require 'rails_helper'

RSpec.describe "Modems", :type => :request do
  describe "GET /modems" do
    it "works! (now write some real specs)" do
      get modems_path
      expect(response.status).to be(200)
    end
  end
end
