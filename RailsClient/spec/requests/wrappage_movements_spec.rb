require 'rails_helper'

RSpec.describe "WrappageMovements", type: :request do
  describe "GET /wrappage_movements" do
    it "works! (now write some real specs)" do
      get wrappage_movements_path
      expect(response).to have_http_status(200)
    end
  end
end
