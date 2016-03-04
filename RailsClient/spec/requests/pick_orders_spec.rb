require 'rails_helper'

RSpec.describe "PickOrders", type: :request do
  describe "GET /pick_orders" do
    it "works! (now write some real specs)" do
      get pick_orders_path
      expect(response).to have_http_status(200)
    end
  end
end
