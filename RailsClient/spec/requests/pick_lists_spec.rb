require 'rails_helper'

RSpec.describe "PickLists", :type => :request do
  describe "GET /pick_lists" do
    it "works! (now write some real specs)" do
      get pick_lists_path
      expect(response.status).to be(200)
    end
  end
end
