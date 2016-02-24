require 'rails_helper'

RSpec.describe "PartClients", type: :request do
  describe "GET /part_clients" do
    it "works! (now write some real specs)" do
      get part_clients_path
      expect(response).to have_http_status(200)
    end
  end
end
