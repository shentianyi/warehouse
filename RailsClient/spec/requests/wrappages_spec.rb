require 'rails_helper'

RSpec.describe "Wrappages", type: :request do
  describe "GET /wrappages" do
    it "works! (now write some real specs)" do
      get wrappages_path
      expect(response).to have_http_status(200)
    end
  end
end
