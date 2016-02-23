require 'rails_helper'

RSpec.describe "Tenants", type: :request do
  describe "GET /tenants" do
    it "works! (now write some real specs)" do
      get tenants_path
      expect(response).to have_http_status(200)
    end
  end
end
