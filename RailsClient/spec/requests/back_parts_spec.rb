require 'rails_helper'

RSpec.describe "BackParts", type: :request do
  describe "GET /back_parts" do
    it "works! (now write some real specs)" do
      get back_parts_path
      expect(response).to have_http_status(200)
    end
  end
end
