require 'rails_helper'

RSpec.describe "PickItemFilters", :type => :request do
  describe "GET /pick_item_filters" do
    it "works! (now write some real specs)" do
      get pick_item_filters_path
      expect(response.status).to be(200)
    end
  end
end
