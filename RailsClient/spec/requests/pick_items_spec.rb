require 'rails_helper'

RSpec.describe "PickItems", :type => :request do
  describe "GET /pick_items" do
    it "works! (now write some real specs)" do
      get pick_items_path
      expect(response.status).to be(200)
    end
  end
end
