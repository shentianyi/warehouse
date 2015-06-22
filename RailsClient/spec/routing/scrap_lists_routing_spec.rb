require "rails_helper"

RSpec.describe ScrapListsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/scrap_lists").to route_to("scrap_lists#index")
    end

    it "routes to #new" do
      expect(:get => "/scrap_lists/new").to route_to("scrap_lists#new")
    end

    it "routes to #show" do
      expect(:get => "/scrap_lists/1").to route_to("scrap_lists#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/scrap_lists/1/edit").to route_to("scrap_lists#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/scrap_lists").to route_to("scrap_lists#create")
    end

    it "routes to #update" do
      expect(:put => "/scrap_lists/1").to route_to("scrap_lists#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/scrap_lists/1").to route_to("scrap_lists#destroy", :id => "1")
    end

  end
end
