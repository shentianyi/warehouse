require 'rails_helper'

RSpec.describe "OrderCars", type: :request do
  describe "GET /order_cars" do
    it "works! (now write some real specs)" do
      get order_cars_path
      expect(response).to have_http_status(200)
    end
  end
end
