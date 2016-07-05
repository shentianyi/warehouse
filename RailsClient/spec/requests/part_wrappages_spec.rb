require 'rails_helper'

RSpec.describe "PartWrappages", type: :request do
  describe "GET /part_wrappages" do
    it "works! (now write some real specs)" do
      get part_wrappages_path
      expect(response).to have_http_status(200)
    end
  end
end
