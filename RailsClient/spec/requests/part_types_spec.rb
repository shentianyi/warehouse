require 'rails_helper'

RSpec.describe "PartTypes", :type => :request do
  describe "GET /part_types" do
    it "works! (now write some real specs)" do
      get part_types_path
      expect(response.status).to be(200)
    end
  end
end
