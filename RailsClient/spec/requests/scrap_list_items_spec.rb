require 'rails_helper'

RSpec.describe "ScrapListItems", type: :request do
  describe "GET /scrap_list_items" do
    it "works! (now write some real specs)" do
      get scrap_list_items_path
      expect(response).to have_http_status(200)
    end
  end
end
