require 'rails_helper'

RSpec.describe "PackageTypes", type: :request do
  describe "GET /package_types" do
    it "works! (now write some real specs)" do
      get package_types_path
      expect(response).to have_http_status(200)
    end
  end
end
