require 'rails_helper'

RSpec.describe "OrderBoxTypes", type: :request do
  describe "GET /order_box_types" do
    it "works! (now write some real specs)" do
      get order_box_types_path
      expect(response).to have_http_status(200)
    end
  end
end
