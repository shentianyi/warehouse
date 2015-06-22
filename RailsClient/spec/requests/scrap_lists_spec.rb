require 'rails_helper'

RSpec.describe "ScrapLists", type: :request do
  describe "GET /scrap_lists" do
    it "works! (now write some real specs)" do
      get scrap_lists_path
      expect(response).to have_http_status(200)
    end
  end
end
