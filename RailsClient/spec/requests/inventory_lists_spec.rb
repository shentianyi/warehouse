require 'rails_helper'

RSpec.describe "InventoryLists", type: :request do
  describe "GET /inventory_lists" do
    it "works! (now write some real specs)" do
      get inventory_lists_path
      expect(response).to have_http_status(200)
    end
  end
end