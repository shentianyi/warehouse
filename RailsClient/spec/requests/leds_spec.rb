require 'rails_helper'

RSpec.describe "Leds", :type => :request do
  describe "GET /leds" do
    it "works! (now write some real specs)" do
      get leds_path
      expect(response.status).to be(200)
    end
  end
end
