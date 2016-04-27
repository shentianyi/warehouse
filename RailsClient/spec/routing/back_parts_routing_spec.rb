require "rails_helper"

RSpec.describe BackPartsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/back_parts").to route_to("back_parts#index")
    end

    it "routes to #new" do
      expect(:get => "/back_parts/new").to route_to("back_parts#new")
    end

    it "routes to #show" do
      expect(:get => "/back_parts/1").to route_to("back_parts#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/back_parts/1/edit").to route_to("back_parts#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/back_parts").to route_to("back_parts#create")
    end

    it "routes to #update" do
      expect(:put => "/back_parts/1").to route_to("back_parts#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/back_parts/1").to route_to("back_parts#destroy", :id => "1")
    end

  end
end
